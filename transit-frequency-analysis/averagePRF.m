function avgFrequency = averagePRF(timestamps)

samplingIntervals = diff(timestamps,1,2);

avgPeriod = mean(samplingIntervals,2);

avgFrequency = 1 ./ avgPeriod;

end
