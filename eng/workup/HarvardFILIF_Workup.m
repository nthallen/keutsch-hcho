%% PREAMBLE
% Convert raw data from the Harvard FILIF instrument into HCHO mixing ratios

% This code assumes that data is stored on the Lenovo D:\ drive
% Change variables in INITIALIZATION section before each experimental run

% 06FEB2018: Creation Date (JDS)
% 17APR2018: v1.00 Release (JDS)

%% INITIALIZATION
% When working up Harvard FILIF data, the user should only have to change
% these parameter variables

run_date = '180423.1';          % Specify run date for loadFILIF.m 
powercal_date = '10APR2018';    % Specify which power meter calibration to use for powercal.m
cal_factor = 50.7;              % counts/s/ppbv/mW; Determined from calibration runs
DitherEnabled = true;           % Specify true if dithering was enabled during data collection
MaxLaserVoltage = 225;          % Specify average max laser voltage seen during experiment
mVwindow = 15;                  % Specify allowed range for possible max laser voltages in refcellcorrect.m
SWScode = 6;                    % Specify chopping used during experiment (5-min chop cycle = 6)
MakeRefCellCorrectPlot = true;  % Plot of ref cell correct graph
MakePlots = true;               % Plot of final HCHO mixing ratio (false or true)
start_cut = ["2018-04-21 16:52:16", "2018-04-21 23:54:00", "2018-04-22 16:45:00", "2018-04-22 14:12:04", "2018-04-22 20:56:00", "2018-04-22 22:14:35", "2018-04-23 20:27:00"];%["09:30:00","10:56:30","11:52:25","12:43:00","18:34:00","19:38:00","21:13:04","21:42:40"];
end_cut   = ["2018-04-21 16:52:24", "2018-04-22 00:20:00", "2018-04-22 17:45:00", "2018-04-22 14:12:05", "2018-04-22 20:57:30", "2018-04-22 22:18:00", "2018-04-23 21:48:30"];%["09:45:00","10:59:00","11:52:35","12:49:00","18:39:30","19:38:35","21:13:24","21:48:04"];

%% LOAD RAW MAT FILES
disp('Loading MAT files')
[BCtr,Data1Hz,Data10Hz] = loadFILIF(run_date); % Load MAT raw data files

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
Data10Hz.ref_rawcps = (10.)*Data10Hz.BCtr_0_a;
Data10Hz.sample_rawcps = (10.)*Data10Hz.BCtr_1_a;


%% PRESSURE CHECK
% Discard points where the pressure was either above 115.3 Torr or less
% than 114.7 Torr

disp('Pressure check data')
Data10Hz.OmegaP_interpolated = interp1(Data1Hz.Thchoeng_1,Data1Hz.OmegaP,Data10Hz.Thchoeng_10);

for i = 1:length(Data10Hz.Thchoeng_10)
    if Data10Hz.OmegaP_interpolated(i) > 115.3 || Data10Hz.OmegaP_interpolated(i) < 114.7
        Data10Hz.ref_rawcps(i) = NaN;
        Data10Hz.sample_rawcps(i) = NaN;
    end
end

%% NORMALIZING RAW COUNTS TO NUMBER OF TRIGGERS
% Since each 10 Hz data point (100 ms) should ideally have 30,000 triggers 
% (the rep rate of the laser is 300 kHz), the raw counts are normalized
% such that no particular point had more or less triggers than any other point.

% First we need to correct the number of triggers due to some being a
% multiple of 2^13 away from the true value

disp('Normalizing to trigger count')
corrected_Ntrigger = trigcorrect(Data10Hz.BCtr_NTrigger);

% Then normalize to 30,000 triggers
Data10Hz.trignorm_ref = 30000*(Data10Hz.ref_rawcps./corrected_Ntrigger); 
Data10Hz.trignorm_sample = 30000*(Data10Hz.sample_rawcps./corrected_Ntrigger);


%% POWER-NORMALIZING RAW COUNTS
% Power-normalize the counts using the LasPwrIn

disp('Normalizing counts to laser power')
power = powercal(Data10Hz.BCtr_LasIn_mW,powercal_date,MakePlots);

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
if DitherEnabled
    [Data10Hz.powernorm_sample, Data10Hz.powernorm_ref] = dithercorrect(Data10Hz);
end

%% COUNTS TO MIXING RATIO CONVERSION

% Find the signal for the concentration by determining difference counts
% between the ONLINE and interpolated OFFLINE positions
Data10Hz.diffcounts = diffcounts(Data10Hz,index);

% Correct for the fact that the laser voltage reported by QNX doesn't
% always track with the actual laser voltage of the laser
disp('Ref Cell Correct Algorithm')
Data10Hz.diffcounts = refcellcorrect(Data10Hz,Data1Hz,MaxLaserVoltage,'interpolate',MakeRefCellCorrectPlot,mVwindow,SWScode);

%Find indices not equal to the online indices and assign NaN
Data10Hz.diffcounts([index.offline;index.scan;index.rm_online;index.rm_offline]) = NaN;

% Apply cal factor to difference counts to obtain the HCHO mixing ratio (10 Hz)
disp('Calculating HCHO mixing ratios using specified cal factor')
Data10Hz.hcho = Data10Hz.diffcounts./cal_factor;

%% TIME CONVERSION
% Convert the time in the Data10Hz structure to something more useful
% Data10Hz.Thchoeng_10 is useful when averaging over longer integration times

disp('Converting instrument posixtime to Matlab datetime object')
Data10Hz.datetime = datetime(Data10Hz.Thchoeng_10,'ConvertFrom','posixtime');

% Convert from Greenwich to Eastern Time
Data10Hz.datetime = Data10Hz.datetime - hours(4);

%% USER-SPECIFIED DATA REMOVAL
% User can specify (in INITIALIZATION) which data points to remove based on time ranges
if ~isempty(start_cut)
    start_cut = datetime(start_cut,'InputFormat','yyyy-MM-dd HH:mm:ss');
    %start_cut.Day = Data10Hz.datetime(1).Day;
    %start_cut.Month = Data10Hz.datetime(1).Month;
    %start_cut.Year = Data10Hz.datetime(1).Year;

    end_cut = datetime(end_cut,'InputFormat','yyyy-MM-dd HH:mm:ss');
    %end_cut.Day = Data10Hz.datetime(1).Day;
    %end_cut.Month = Data10Hz.datetime(1).Month;
    %end_cut.Year = Data10Hz.datetime(1).Year;

    start_time_index = NaN(length(start_cut));
    end_time_index = NaN(length(start_cut));
    for i = 1:length(start_cut)
        start_time_index(i) = find(Data10Hz.datetime == start_cut(i));
        end_time_index(i) = find(Data10Hz.datetime == end_cut(i));
    end

    % Make all mixing ratios a NaN that's between the start and end times

    for n = 1:length(start_cut)
        Data10Hz.hcho(start_time_index(n):end_time_index(n)) = NaN;
        Data10Hz.diffcounts(start_time_index(n):end_time_index(n)) = NaN;
    end
end
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

%% INTEGRATION TIME
% Raw data from Harvard FILIF is reported at 10 Hz. Let's also calculate
% the 1 sec averaged data as well

% disp('Calculating 1 Hz data from the original 10 Hz data')
% [Data1Hz.posixtime, Data1Hz.hcho] = binavg(Data10Hz.Thchoeng_10, Data10Hz.hcho, 1);
% 
% % Convert from posixtime to datetime object and from Greenwich to Eastern time
% Data1Hz.datetime = datetime(Data1Hz.posixtime,'ConvertFrom','posixtime');
% Data1Hz.datetime = Data1Hz.datetime - hours(4);

%% PLOT OF HCHO MIXING RATIO
% Generates plot of 10 Hz data with 1 Hz HCHO mixing ratio superimposed on top

% disp('Plotting 10 and 1 Hz data')
% if MakePlots
%     figure,plot(Data10Hz.datetime,Data10Hz.hcho)
%     hold on
%     plot(Data1Hz.datetime,Data1Hz.hcho)
%     title(run_date)
%     xlabel('Time')
%     ylabel('HCHO / ppbv')
% end