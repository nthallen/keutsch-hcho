function [dithercorrect_sample, dithercorrect_ref] = dithercorrect(Data10Hz)

% When dithering is enabled in QNX, we need to correct for laser
% wavelengths where the laser was not on the maximum of the HCHO spectral
% line

% Find online indices for each online/offline cycle. Remove first few
% when necessary in order to minimize their effect on the bin average
dither.online = find(Data10Hz.BCtr_LVstat==10);
[dither.online, dither.rm_online] = RemoveFirstPoints(dither.online, 2);

dither.online_chunks  = chunker(dither.online);

% Now find the average (power and trigger-normalized) counts from the
% REFERENCE CELL for each online cycle. Also find the associated laser
% voltage and time

l=size(dither.online_chunks,1);
dither.online_ref_avg=nan(l,1);
dither.online_LaserV=nan(l,1);
dither.time_avg=nan(l,1);

for i=1:l
   j = dither.online_chunks(i,1):dither.online_chunks(i,2);
   dither.online_ref_avg(i) = nanmean(Data10Hz.powernorm_ref(j));
   dither.online_LaserV(i)  = nanmean(Data10Hz.BCtr_LaserV(j));
   dither.time_avg(i)       = nanmean(Data10Hz.Thchoeng_10(j));
end

% Use a 4-point moving average in order to identify the center of the HCHO
% spectral line (LaserV) during dithering.

dither.movingavg = movmean(dither.online_LaserV,4);

% Determine how far away (in LaserV) that each point is away from the line
% center

dither.distanceFromLineCenter = dither.online_LaserV - dither.movingavg;

% Load correction factors file derived for the HCHO spectral line at 115
% Torr (code to generate this file is located below)

dither.CorrectionLookupTable = load('dithercorrectfactors.mat');

% Using the interpolation function, find the correction factors for our
% actual data
dither.CorrectionValues = interp1(dither.CorrectionLookupTable.offset, dither.CorrectionLookupTable.correct_factor_avg, dither.distanceFromLineCenter);

% Correct the ONLINE data from both the sample AND reference cells

length=size(dither.online_chunks,1);

for i=1:length
    j = dither.online_chunks(i,1):dither.online_chunks(i,2);
    Data10Hz.powernorm_ref(j) = Data10Hz.powernorm_ref(j)/dither.CorrectionValues(i);
    Data10Hz.powernorm_sample(j) = Data10Hz.powernorm_sample(j)/dither.CorrectionValues(i);
end

dithercorrect_sample = Data10Hz.powernorm_sample;
dithercorrect_ref = Data10Hz.powernorm_ref;

% %% Determination of Correction Factors (at 115 Torr) using multiple scans
% % Correction factor (correct_factor) based upon distance from the line center
% 
% % First find indices that correspond to scan data points and plot these
% % scans
% 
% dither.scan   = find(Data10Hz.BCtr_LVstat==1);
% scantimes = Data10Hz.Thchoeng_10(dither.scan);
% scanvals = Data10Hz.powernorm_ref(dither.scan);
% laserVs = Data10Hz.BCtr_LaserV(dither.scan);
% figure,plot(scantimes,scanvals)
% hold on
% plot(scantimes,laserVs)
% 
% % First, create an array where each row corresponds to a different scan
% % This array is called all_scans with corresponding laser voltages in
% % lasVolts
% 
% %Chunk scan indices
% scan_chunks  = chunker(dither.scan);
% 
% all_scans = [];
% lasVolts = [];
% for i=1:length(scan_chunks)
%     temp = Data10Hz.powernorm_ref(scan_chunks(i,1):scan_chunks(i,2));
%     l=length(temp);
%     for j=1:l
%         all_scans(i,j)= temp(j);
%     end
%     lasVolts = Data10Hz.BCtr_LaserV(scan_chunks(i,1):scan_chunks(i,2));
% end
% 
% % Remove any scans that have a NaN for any Laser voltage
% all_scans(any(isnan(all_scans),2),:) = [];
% 
% 
% % Now just choose lasVolts whose range covers the dominant spectral line
% % and nothing more
% 
% %range start is 210 mV, so range_start_index = 45
% %range end is 245 mV, so range_end_index = 198
% 
% all_scans_parsed = all_scans(:,45:198);
% lasVolts_parsed = lasVolts(45:198);
% 
% %a = all_scans_parsed(100,:);
% %f = fit(lasVolts_parsed,a','gauss2');
% %figure,plot(f,lasVolts_parsed,a)
% 
% 
% [m,n] = size(all_scans_parsed);
% correct_factor = [];
% for i = 1:m
%     %Fit a Gaussian curve to each spectral line. Could be improved with a
%     %Voigt profile, but Gaussian is sufficient for our purposes
%     current_scan = all_scans_parsed(i,:);
%     f = fit(lasVolts_parsed,current_scan','gauss2');
%     
%     %Generate a fine mesh to evaluate the fit on discrete points
%     mesh = (lasVolts_parsed(1):0.01:lasVolts_parsed(end));
%     
%     %Evaluate the Gaussian fit on the fine mesh
%     meshvals = NaN(length(mesh),1);
%     for j = 1:length(mesh)
%         meshvals(j) = f(mesh(j));
%     end
%     
%     %Determine maximum value (and its corresponding index) on the fine mesh
%     [max_val max_index]= max(meshvals);
%     max_lasV = mesh(max_index);
%     
%     %Divide by the maximum value to obtain the correction factor for offset
%     %(in mV) from the center of the spectral line
%     correction_factors = meshvals/max_val;
%     
%     %Just probe laser voltages +/- 4 mV from maximum of laser voltage
%     lasV= max_lasV-4:0.05:max_lasV+4;
%     lasV_indices = [];
%     correction_factors_subset = [];
%     for k=1:length(lasV)
%         %To find a noninteger value, use a tolerance value rather than an equal sign. 
%         %Otherwise, the result is sometimes an empty matrix due to 
%         %floating-point roundoff error.
%         lasV_indices(k) = find(abs(mesh-lasV(k))<0.001);
%         correction_factors_subset(k) = correction_factors(lasV_indices(k));
%     end
% 
%     correct_factor(i,:) = correction_factors_subset;
%     
% end
% 
% % NOTE: You may have to look through all the rows of correct_factor to see
% % if there are any scans which are outliers (and thus throw off the general
% % trend - i.e. mean and standard deviation)
% 
% % Now find the mean and standard deviation for all the scans combined
% % together (mind the note right above)
% [t,v] = size(correct_factor);
% correct_factor_avg = [];
% correct_factor_std = [];
% for p = 1:v
%     correct_factor_avg(p) = mean(correct_factor(:,p));
%     correct_factor_std(p) = std(correct_factor(:,p));
% end
% offset = lasV - max_lasV;
% 
% Note: The .mat file should contain the following variables:
% (1) offset
% (2) correct_factor_avg
% (3) correct_factor_std
%
% %% END
