%refcellcorrect_return = refcellcorrect(Data10Hz,Data1Hz,maxLaserV,method,plotme)

% PURPOSE: Correct for any drift in difference count signal that resulted
% in shifting of the laser voltage or peak position (that wasn't recorded
% by the instrument)

function refcellcorrect_return = refcellcorrect(Data10Hz,Data1Hz,maxLaserV,method,plotme,mVwindow,SWScode)
 
% Find indices of ONLINE and SCAN points
refcellcorrect.online = find(Data10Hz.BCtr_LVstat==10);
refcellcorrect.scan   = find(Data10Hz.BCtr_LVstat==1);

% Chunk the scan indices
refcellcorrect.scan_chunks = chunker(refcellcorrect.scan);

l=size(refcellcorrect.scan_chunks,1);
refcellcorrect.time_max=nan(l,1);
refcellcorrect.scan_max_value=nan(l,1);
refcellcorrect.scan_max_LasV=nan(l,1);

for i=1:l
   j = refcellcorrect.scan_chunks(i,1):refcellcorrect.scan_chunks(i,2);
   % We have to add on the value of refcellcorrect.scan_chunks(i,1) since
   % scan_max_index is the index for a subset of data in Data10Hz.powernorm_ref
   % rather than the entire array
   [refcellcorrect.scan_max_value(i), scan_max_index] = max(Data10Hz.powernorm_ref(j));
   max_lasV = Data10Hz.BCtr_LaserV(refcellcorrect.scan_chunks(i,1) + scan_max_index);
   refcellcorrect.time_max(i) = Data10Hz.Thchoeng_10(refcellcorrect.scan_chunks(i,1) + scan_max_index);
   
   % Sometimes, the start or end of a scan has an extraneously high point
   % that throws off this algo. This if statement ensures that this doesn't
   % happen
   if (max_lasV < (maxLaserV - mVwindow) || max_lasV > (maxLaserV + mVwindow))
       refcellcorrect.scan_max_value(i) = NaN;
       refcellcorrect.time_max(i) = NaN;
   end
end

% Remove any outliers
A = isoutlier(refcellcorrect.scan_max_value,'mean');
for i=1:length(A)
    if A(i)==1
        refcellcorrect.scan_max_value(i) = NaN;
        refcellcorrect.time_max(i) = NaN;
    end
end

% Only consider data after we started our five-minute chopping cycle
start_time = Data1Hz.Thchoeng_1(Data1Hz.SWStat == SWScode);
start_time = start_time(1);

for i=1:length(refcellcorrect.time_max)
    if (refcellcorrect.time_max(i) - start_time < 0 || isnan(refcellcorrect.time_max(i)))
        refcellcorrect.scan_max_value(i) = NaN;
        refcellcorrect.time_max(i) = NaN;
    end
end

% Makes sure that if there was a NaN in scan_max_value that a NaN also
% appears for the corresponding time so that both are removed in the next
% bit of code
for i=1:length(refcellcorrect.time_max)
    if isnan(refcellcorrect.scan_max_value(i))
        refcellcorrect.time_max(i) = NaN;
    end
end


% Remove NaNs from dataset before fitting
refcellcorrect.time_max(any(isnan(refcellcorrect.time_max),2),:) = [];
refcellcorrect.scan_max_value(any(isnan(refcellcorrect.scan_max_value),2),:) = [];


switch method
    case 'interpolate' 
        
        % Generate a moving mean to minimize the effect of noise in each
        % of the max peak heights
        refcellcorrect.scan_max_value_movmean = movmean(refcellcorrect.scan_max_value,8);
        
        % Interpolate the max peak heights
        refcellcorrect.scan_max_interp = interp1(refcellcorrect.time_max,refcellcorrect.scan_max_value_movmean,Data10Hz.Thchoeng_10);
        
        if plotme
            figure,plot(Data10Hz.Thchoeng_10,refcellcorrect.scan_max_interp)
            hold on
            plot(refcellcorrect.time_max,refcellcorrect.scan_max_value,'.')
        end
        
        % Find correction ratio by dividing the interpolated heights by the power
        % and trigger-normalized ref counts
        ratio=refcellcorrect.scan_max_interp./Data10Hz.powernorm_ref;
        
    case 'polyfit' 
        
        f = fit(refcellcorrect.time_max,refcellcorrect.scan_max_value,'poly1');
        
        if plotme
            figure,plot(f,refcellcorrect.time_max,refcellcorrect.scan_max_value)
        end
        
        % Find ratio using REFERENCE cell
        correctionvalues = f(Data10Hz.Thchoeng_10);
        ratio = correctionvalues./Data10Hz.powernorm_ref;
        
    otherwise
        error('Specified method not supported')
end


refcellcorrect_return = Data10Hz.diffcounts.*ratio;
