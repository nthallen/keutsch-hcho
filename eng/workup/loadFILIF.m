function [BCtr,Data1Hz,Data10Hz] = loadFILIF(run_date)

%% PREAMBLE
% Loads needed MAT files necessary for Harvard FILIF data workup

% Inputs
% run_date: Date of run (e.g. '171130.2')
% This code assumes that data is stored on the Lenovo D:\ drive

% 06FEB2018: JDS

%% DIRECTORY SETUP and LOADING MAT FILES

% Folder containing files from an experimental run on Harvard FILIF
RAWdir = ['D:\Data\HCHO\RAW\',run_date,'\'];

% Adds raw file directory to MATLAB path
addpath(RAWdir)

% File paths of raw data MAT files
BCtr_path = [RAWdir,'BCtr.mat'];
Data_1Hz_path = [RAWdir,'hchoeng_1.mat'];
Data_10Hz_path = [RAWdir,'hchoeng_10.mat'];

BCtr = load(BCtr_path);
Data1Hz = load(Data_1Hz_path);
Data10Hz = load(Data_10Hz_path);
