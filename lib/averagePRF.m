function avgFrequency = averagePRF(timestamps)

% SPDX-License-Identifier: BSD-3-Clause

samplingIntervals = diff(timestamps,1,2);

avgPeriod = mean(samplingIntervals,2);

avgFrequency = 1 ./ avgPeriod;

end
