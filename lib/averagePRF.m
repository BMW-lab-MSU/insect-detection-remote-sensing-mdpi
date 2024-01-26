function avgFrequency = averagePRF(timestamps)
% averagePRF compute the average pulse repetition frequency
%
% avgFrequency = averagePRF(timestamps) computes the average pulse repetition
% frequency given by the timestamps vector. Each timestamp in `timestamps`
% corresponds to one pulse.
%
% In general, the separation between pulses/timestamps is not constant, so
% that's why we compute the average value. The average PRF is our average
% sampling frequency.

% SPDX-License-Identifier: BSD-3-Clause

samplingIntervals = diff(timestamps,1,2);

avgPeriod = mean(samplingIntervals,2);

avgFrequency = 1 ./ avgPeriod;

end
