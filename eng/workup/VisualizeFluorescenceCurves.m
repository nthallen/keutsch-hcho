%% PREAMBLE
% Plot fluorescence decay curves from Harvard FILIF

%% FOLDER INITIALIZATION
% Specify where FILIF raw data is located by its run date

run_date = '181011.1'; % Specify raw data folder name (e.g. '181026.1')
RAWdir = ['D:\Data\HCHO\RAW\',run_date,'\'];
addpath(RAWdir)

%% LOADING MAT FILES AND PARSING
% Load MAT raw data files
[BCtr,Data1Hz,Data10Hz] = loadFILIF(run_date); % Load MAT raw data files

% Obtain dimensions
rows = size(BCtr.BCtr0,1);
cols = size(BCtr.BCtr0,2);
bins = 1:cols-2;

% Removing first and last columns of BCtr as it doesn't correspond to curves
BCtr.BCtr0(:,1) = [];
BCtr.BCtr0(:,end) = [];

%% PLOTTING FLUORESCENCE CURVES

starting = 40000; % Specify first fluorescence curve to plot 40000
ending   = 41000; % Specify last fluorescence curve to plot 41000

figure
for i=starting:ending
    plot(BCtr.BCtr0(i,:))
    hold on
end
xlabel('Bins')
ylabel('Raw Counts')
title('Fluorescence Curves')