function trigcorrect = trigcorrect(BCtr_NTrigger)

% The number of triggers reported by the counter sometimes is off from the
% true number by a multiple of 2^13 (above and below the true value). 

% The standard deviation of the true value was 123 triggers. Let's set the
% upper and lower bounds by 10 standard deviations from the mean

TrueValueMean = 28097;
TrueValueStd = 123;

for i = 1:length(BCtr_NTrigger)
    
    if BCtr_NTrigger(i) > (TrueValueMean - 1*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean - 1*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) + (2^13);
        
    elseif BCtr_NTrigger(i) > (TrueValueMean - 2*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean - 2*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) + 2*(2^13);
        
     elseif BCtr_NTrigger(i) > (TrueValueMean - 3*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean - 3*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) + 3*(2^13);
        
     elseif BCtr_NTrigger(i) > (TrueValueMean + 1*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean + 1*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) - (2^13);
        
     elseif BCtr_NTrigger(i) > (TrueValueMean + 2*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean + 2*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) - 2*(2^13);
        
     elseif BCtr_NTrigger(i) > (TrueValueMean + 3*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean + 3*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) - 3*(2^13);
        
     elseif BCtr_NTrigger(i) > (TrueValueMean + 4*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean + 4*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) - 4*(2^13);  
        
     elseif BCtr_NTrigger(i) > (TrueValueMean + 5*(2^13))-10*TrueValueStd && BCtr_NTrigger(i) < (TrueValueMean + 5*(2^13))+10*TrueValueStd
        BCtr_NTrigger(i) = BCtr_NTrigger(i) - 5*(2^13);   
        
    end
end

% We've corrected for trigger values containing a multiple of 2^13 using a
% methodical approach, but there are still entries containing a multiple of
% 2^13 and additional (or fewer) triggers. To fix this problem, we will
% assign NaNs to these few points (very few points should be receiving a NaN).

for i = 1:length(BCtr_NTrigger)
    if BCtr_NTrigger(i) < 27000 || BCtr_NTrigger(i) > 33000
        BCtr_NTrigger(i) = NaN;
    end
end

trigcorrect = BCtr_NTrigger;