function diffcounts = diffcounts(Data10Hz, index)

%divide offline indices into each cycle
offline_indices = index.offline;
offline_chunks  = chunker(offline_indices);

%Find average counts for each offline data chunk. Using interpolation 
%between the two adjacent offline counts averages, put onlines and average
%offlines on same time basis.

l=size(offline_chunks,1);
offline_avg=nan(l,1);
time_avg=nan(l,1);

for i=1:l
   j = offline_chunks(i,1):offline_chunks(i,2);
   offline_avg(i) = nanmean(Data10Hz.powernorm_sample(j));
   time_avg(i) = nanmean(Data10Hz.Thchoeng_10(j));
end

offline_interpolated = interp1(time_avg,offline_avg,Data10Hz.Thchoeng_10);

%Subtract
diffcounts = Data10Hz.powernorm_sample - offline_interpolated;
