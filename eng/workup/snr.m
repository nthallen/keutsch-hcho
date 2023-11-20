%% PREAMBLE
% Determine the best binning settings for optimal signal-to-noise ratio on
% Harvard FILIF

% You should first navigate to the 181027.2 folder and run this code from
% that directory

start_bin = 12;
end_bin = 45;

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

[BCtr,Data1Hz,Data10Hz] = loadFILIF(s.run_date); % Load MAT raw data files

%% TIME CONVERSION
% Convert the time in the Data10Hz and Data1Hz structures to Matlab
% datetime objects. Please note that Data10Hz.Thchoeng_10 is needed when 
% averaging over longer integration times (with binavg.m)

Data10Hz.datetime = datetime(Data10Hz.Thchoeng_10,'ConvertFrom','posixtime');
Data1Hz.datetime = datetime(Data1Hz.Thchoeng_1,'ConvertFrom','posixtime');

if s.local_time_convert
    Data10Hz.datetime = Data10Hz.datetime - hours(s.time_adjust);
    Data1Hz.datetime = Data1Hz.datetime - hours(s.time_adjust);
end

%% CONVERT TO CPS

% QNX reports counts per 100 milliseconds rather than per second. Thus,
% this section converts both ref and sample cell counts to counts per 
% second by multiplying these raw counts by 10.

% BCtr_0: Ref cell
% BCtr_1: Sample cell

Data10Hz.BCtr_0_a_rev = [];
Data10Hz.BCtr_1_a_rev = [];

for i = 1:length(BCtr.BCtr0)
    Data10Hz.BCtr_0_a_rev(i) = sum(BCtr.BCtr0(i,start_bin:end_bin));
    Data10Hz.BCtr_1_a_rev(i) = sum(BCtr.BCtr1(i,start_bin:end_bin));
end

Data10Hz.BCtr_0_a_rev = Data10Hz.BCtr_0_a_rev';
Data10Hz.BCtr_1_a_rev = Data10Hz.BCtr_1_a_rev';

Data10Hz.ref_rawcps    = (10.)*Data10Hz.BCtr_0_a_rev;
Data10Hz.sample_rawcps = (10.)*Data10Hz.BCtr_1_a_rev;

%% PRESSURE CHECK
% Discard points whose pressures are above or below the specified values in config.ini

Data10Hz.OmegaP_interpolated = interp1(Data1Hz.Thchoeng_1,Data1Hz.OmegaP,Data10Hz.Thchoeng_10);

for i = 1:length(Data10Hz.Thchoeng_10)
    if Data10Hz.OmegaP_interpolated(i) > s.max_pressure || Data10Hz.OmegaP_interpolated(i) < s.min_pressure
        Data10Hz.ref_rawcps(i) = NaN;
        Data10Hz.sample_rawcps(i) = NaN;
    end
end

%% LASER POWER CHECK
% Remove points below the acceptable laser power specified in config.ini

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

Data10Hz.trignorm_ref = 49388*(Data10Hz.ref_rawcps./Data10Hz.BCtr_NTrigger); 
Data10Hz.trignorm_sample = 49388*(Data10Hz.sample_rawcps./Data10Hz.BCtr_NTrigger);

%% POWER-NORMALIZING RAW COUNTS
% Power-normalize the counts using the LasPwrIn

load('Real_Thorlabs_LaserPwr_ForThisDataSetOnly.mat')

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

%% SIGNAL: DIFFERENCE COUNTS
% The counts for the signal and noise are being taken from the SAMPLE cell

% Find the signal for the concentration by determining difference counts
% between the ONLINE and interpolated OFFLINE positions
Data10Hz.diffcounts = diffcounts(Data10Hz,index);

%Find indices not equal to the online indices and assign NaN
Data10Hz.diffcounts([index.offline;index.scan;index.rm_online;index.rm_offline]) = NaN;

% Take last ~30 min of equilibrated difference counts of calibration and assign as the signal
% Start: 21:40:49 (195151)
% End: 22:08:55 (212012)
signal = nanmean(Data10Hz.diffcounts(195151:212012));

%% NOISE

%Data10Hz.powernorm_sample([index.online;index.scan;index.rm_online;index.rm_offline]) = NaN;
%noise = nanmean(Data10Hz.powernorm_sample(195196:212021));

noise = nanstd(Data10Hz.diffcounts(195151:212012));

%% SIGNAL-TO-NOISE RATIO

signaltonoiseratio = signal/noise;
calfactor = signal/18.75;

disp('The signal-to-noise ratio is:')
disp(signaltonoiseratio)

disp('The cal factor is:')
disp(calfactor)

