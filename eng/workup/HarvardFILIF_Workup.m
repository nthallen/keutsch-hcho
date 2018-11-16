%% PREAMBLE
% Convert raw data from the Harvard FILIF instrument into HCHO mixing ratios

% Please navigate to the directory containing your config.ini file before
% running this script

% 06FEB2018: Creation Date (JDS)
% 17APR2018: v1.00 Release (JDS)
% 17JUN2018: v1.50 Release (JDS): Added graphical removal capabilities
% 30JUN2018: v2.00 Release (JDS): Ability to save workup settings; code reorganization
% 30OCT2018: v3.00 Release (JDS): Accommodating HUVFL and code optimization; addition of config.ini capabilities

%% SETTINGS AND FOLDER INITIALIZATION
% Settings for a run are located in a user-defined config.ini file. Please
% see an example config.ini file for more details.

% Load configuration file containing settings
s = ini2struct('config.ini');
fields = fieldnames(s); % List field names in the settings structure
for i = 1:numel(fields) 
    s.(fields{i}) = str2double(s.(fields{i})); % Convert character strings to numerical values
end

s.run_date = num2str(s.run_date);
RAWdir = ['D:\Data\HCHO\RAW\',s.run_date,'\'];
addpath(RAWdir)

%% LOAD RAW MAT FILES

disp('Loading MAT files')
[BCtr,Data1Hz,Data10Hz] = loadFILIF(s.run_date); % Load MAT raw data files

%% TIME CONVERSION
% Convert the time in the Data10Hz and Data1Hz structures to Matlab
% datetime objects. Please note that Data10Hz.Thchoeng_10 is needed when 
% averaging over longer integration times (with binavg.m)

disp('Converting instrument posixtime to Matlab datetime object')
Data10Hz.datetime = datetime(Data10Hz.Thchoeng_10,'ConvertFrom','posixtime');
Data1Hz.datetime = datetime(Data1Hz.Thchoeng_1,'ConvertFrom','posixtime');

if s.local_time_convert
    Data10Hz.datetime = Data10Hz.datetime - hours(s.time_adjust);
    Data1Hz.datetime = Data1Hz.datetime - hours(s.time_adjust);
end

%% CONVERT TO CPS
% Unlike most other PMTs, our Sens-Tech PMTs output a TTL signal where a
% rising and falling edge of the signal correspond to two photons rather
% than just to a single photon. (Note: If one were to count photons with an
% oscilloscope, it would count half the photons since the scope would only
% count the rising OR falling edge and not both.

% QNX reports counts per 100 milliseconds rather than per second. Thus,
% this section converts both ref and sample cell counts to counts per 
% second by multiplying these raw counts by 10.

% BCtr_0: Ref cell
% BCtr_1: Sample cell

disp('Converting raw counts to CPS')
% Data10Hz.ref_rawcps    = (10.)*Data10Hz.BCtr_0_a;
% Data10Hz.sample_rawcps = (10.)*Data10Hz.BCtr_1_a;

Data10Hz.BCtr_0_a_rev = [];
Data10Hz.BCtr_1_a_rev = [];

for i = 1:length(BCtr.BCtr0)
    Data10Hz.BCtr_0_a_rev(i) = sum(BCtr.BCtr0(i,7:80));
    Data10Hz.BCtr_1_a_rev(i) = sum(BCtr.BCtr1(i,7:80));
end

Data10Hz.BCtr_0_a_rev = Data10Hz.BCtr_0_a_rev';
Data10Hz.BCtr_1_a_rev = Data10Hz.BCtr_1_a_rev';

Data10Hz.ref_rawcps    = (10.)*Data10Hz.BCtr_0_a_rev;
Data10Hz.sample_rawcps = (10.)*Data10Hz.BCtr_1_a_rev;

%% PRESSURE CHECK
% Discard points whose pressures are above or below the specified values in config.ini

disp('Pressure check data')
Data10Hz.OmegaP_interpolated = interp1(Data1Hz.Thchoeng_1,Data1Hz.OmegaP,Data10Hz.Thchoeng_10);

for i = 1:length(Data10Hz.Thchoeng_10)
    if Data10Hz.OmegaP_interpolated(i) > s.max_pressure || Data10Hz.OmegaP_interpolated(i) < s.min_pressure
        Data10Hz.ref_rawcps(i) = NaN;
        Data10Hz.sample_rawcps(i) = NaN;
    end
end

%% LASER POWER CHECK
% Remove points below the acceptable laser power specified in config.ini

disp('Discarding points below acceptable laser power limit')
for i = 1:length(Data10Hz.ref_rawcps)
    if Data10Hz.BCtr_LasIn_mW(i) < s.min_acceptable_power
        Data10Hz.ref_rawcps(i)    = NaN;
        Data10Hz.sample_rawcps(i) = NaN;
        Data10Hz.BCtr_LasIn_mW(i)   = NaN;
    end    
end

%% NORMALIZING RAW COUNTS TO NUMBER OF TRIGGERS
% Since each 10 Hz data point (100 ms) should ideally have 49,388 triggers 
% (the rep rate of the laser is 493.88 kHz), the raw counts are normalized
% such that no particular point had more or less triggers than any other point.

disp('Normalizing to trigger count')
Data10Hz.trignorm_ref = 49388*(Data10Hz.ref_rawcps./Data10Hz.BCtr_NTrigger); 
Data10Hz.trignorm_sample = 49388*(Data10Hz.sample_rawcps./Data10Hz.BCtr_NTrigger);

%% REMOVE DATA BY GRAPHICAL SELECTION (OPTIONAL)
% Manually remove points by using the brush tool provided in the Matlab
% figure options. Allows for easy removal of data when no readily-definable
% criterion exists to remove the data. Do not use this ability to
% 'cherry-pick' the data!

file_exist_check = exist(fullfile(RAWdir,'RemovedPoints.mat'), 'file');

if file_exist_check == 2
    load('RemovedPoints.mat')
    
    for i = 1:length(Data10Hz.Thchoeng_10)
        if ptsRemoved(i)
            Data10Hz.trignorm_ref(i) = NaN;
            Data10Hz.trignorm_sample(i) = NaN;
            Data10Hz.BCtr_LasIn_mW(i) = NaN;
        end
    end 
    loaded_ptsRemoved = ptsRemoved;
end

if s.graphical_removal
    
    figure
    h = pan;
    h.Motion = 'horizontal';
    h.Enable = 'on';
    ax1 = subplot(3,1,1);
    hLines = plot(Data10Hz.datetime,Data10Hz.trignorm_ref);

    ax2 = subplot(3,1,2);
    plot(Data10Hz.datetime,Data10Hz.BCtr_LasIn_mW) %Data10Hz.hcho OR Data10Hz.BCtr_LasIn_mW
    
    ax3 = subplot(3,1,3);
    plot(Data1Hz.datetime,Data1Hz.LV_online)

    linkaxes([ax1,ax2,ax3],'x')

    % Start brushing mode and wait for user to hit "Enter" when done
    brush on
    disp('Hit Enter in command window when done brushing')
    pause

    % Loop through each graphics object
    for k = 1:numel(hLines)
        % Check that the property is valid for that type of object
        % Also check if any points in that object are selected
        if isprop(hLines(k),'BrushData') && any(hLines(k).BrushData)
            % Output the selected data to the base workspace with assigned name
            ptsRemoved = logical(hLines(k).BrushData.');
        end
    end  
end

% This step makes sure that the loaded ptsRemoved isn't overwritten by the
% new points being removed
if file_exist_check == 2
    ptsRemoved = ptsRemoved|loaded_ptsRemoved; % logical OR
end

if exist('ptsRemoved','var') == 1
    
    save(fullfile(RAWdir,'RemovedPoints.mat'),'ptsRemoved');

    for i = 1:length(Data10Hz.Thchoeng_10)
        if ptsRemoved(i)
            Data10Hz.trignorm_ref(i) = NaN;
            Data10Hz.trignorm_sample(i) = NaN;
            Data10Hz.BCtr_LasIn_mW(i) = NaN;
        end
    end
end

clear('ax1','ax2','ax3','h','hLines','file_exist_check')

%% POWER-NORMALIZING RAW COUNTS
% Power-normalize the counts using the LasPwrIn

disp('Normalizing counts to laser power')
power = Data10Hz.BCtr_LasIn_mW;

Data10Hz.powernorm_ref = Data10Hz.trignorm_ref./power;
Data10Hz.powernorm_sample = Data10Hz.trignorm_sample./power;

%% DATA POINT ASSIGNMENTS
% Determine indices for points that either correspond to ONLINE, OFFLINE,
% or SCAN

index.online   = find(Data10Hz.BCtr_LVstat==10); % ONLINE = 10 from BCtr_LVStat
index.offline  = find(Data10Hz.BCtr_LVstat==12); % OFFLINE = 12 from BCtr_LVStat
index.scan     = find(Data10Hz.BCtr_LVstat==1);  % SCAN = 1 from BCtr_LVStat

[index.online, index.rm_online]  = RemoveFirstPoints(index.online, 2);
[index.offline, index.rm_offline] = RemoveFirstPoints(index.offline, 2);

% Fix scan index issue (FPGA switches to online label before the scan is
% actually complete)
index.scan = scancorrect(index.scan);

%% DITHERING CORRECTION
% If online dithering was enabled by the user during data collection, we 
% have to correct for this here

disp('Dither Correction')
if s.dither_enable
    [Data10Hz.powernorm_sample, Data10Hz.powernorm_ref] = dithercorrect(Data10Hz);
end

%% COUNTS TO MIXING RATIO CONVERSION

% Find the signal for the concentration by determining difference counts
% between the ONLINE and interpolated OFFLINE positions
Data10Hz.diffcounts = diffcounts(Data10Hz,index);

% Correct for the fact that the laser voltage reported by QNX doesn't
% always track with the actual laser voltage of the laser
%disp('Ref Cell Correct Algorithm')
%Data10Hz.diffcounts = refcellcorrect(Data10Hz,Data1Hz,s.max_laser_voltage,'interpolate',s.make_ref_cell_correct_plot,s.mv_window,s.swscode);

%Find indices not equal to the online indices and assign NaN
Data10Hz.diffcounts([index.offline;index.scan;index.rm_online;index.rm_offline]) = NaN;

% Apply cal factor to difference counts to obtain the HCHO mixing ratio (10 Hz)
disp('Calculating HCHO mixing ratios using specified cal factor')
Data10Hz.hcho = Data10Hz.diffcounts./s.cal_factor;


%% REMOVE DATA BY GRAPHICAL SELECTION POST-PROCESSING (OPTIONAL)
% Now that HCHO mixing ratios have been calculated, here is another
% opportunity to appropriately remove extraneous points.

if s.graphical_removal_post
    
    figure
    h = pan;
    h.Motion = 'horizontal';
    h.Enable = 'on';
    hLines = plot(Data10Hz.datetime,Data10Hz.hcho);

    % Start brushing mode and wait for user to hit "Enter" when done
    brush on
    disp('Hit Enter in command window when done brushing')
    pause

    % Loop through each graphics object
    for k = 1:numel(hLines)
        % Check that the property is valid for that type of object
        % Also check if any points in that object are selected
        if isprop(hLines(k),'BrushData') && any(hLines(k).BrushData)
            % Output the selected data to the base workspace with assigned name
            ptsRemoved_PostProcessing = logical(hLines(k).BrushData.');
        end
    end
    
    if exist('ptsRemoved_PostProcessing','var') == 1
        for i = 1:length(Data10Hz.Thchoeng_10)
            if ptsRemoved_PostProcessing(i)
                Data10Hz.hcho(i) = NaN;
            end
        end
        
        % This step makes sure that the pre-processing ptsRemoved isn't overwritten
        overwrite_protection = exist('ptsRemoved','var'); 
        if overwrite_protection == 1 
            ptsRemoved = ptsRemoved|ptsRemoved_PostProcessing; % logical OR
            save(fullfile(RAWdir,'RemovedPoints.mat'),'ptsRemoved');
        else
            ptsRemoved = ptsRemoved_PostProcessing;
            save(fullfile(RAWdir,'RemovedPoints.mat'),'ptsRemoved');
        end
    end   
end

clear('h','hLines','k','i')

%% OUTLIER REMOVAL
% Remove outliers more than three local scaled MAD from the local median
% Note: movmean (removing outliers more than three local standard deviations
% from the local mean) is too strongly affected by outliers

disp('Removing outliers')
figure,plot(Data10Hz.datetime,Data10Hz.hcho)
hold on
outlier_logical_array = isoutlier(Data10Hz.hcho,'movmedian',50);
for i=1:length(outlier_logical_array)
    if outlier_logical_array(i)==1
        Data10Hz.hcho(i) = NaN;
        Data10Hz.diffcounts(i) = NaN;
    end
end
plot(Data10Hz.datetime,Data10Hz.hcho)


%% PLOT OF HCHO MIXING RATIO
% Generates plot of the 10 Hz HCHO mixing ratio

disp('Plotting 10 Hz data')
if s.make_plots
    figure,plot(Data10Hz.datetime,Data10Hz.hcho)
    title(s.run_date)
    xlabel('Time')
    ylabel('HCHO / ppbv')
end

%% SAVE PROCESSED HCHO DATA AS MAT FILE
% Save 10 Hz HCHO mixing ratio data as a MAT file in your RAW directory.
% This file can then be sent around to others as your processed data file.

FILIF.datetime = Data10Hz.datetime;
FILIF.hcho     = Data10Hz.hcho;
FILIF.datetime1Hz = Data1Hz.datetime;
FILIF.flag     = Data1Hz.Flag;
save(fullfile(RAWdir,'FILIF_ProcessedHCHO.mat'),'FILIF');
