function [harmonicFrequencies, harmonicIdx] = findHarmonics(peakLocations, fundamentalLocation, nHarmonics, avgSamplingFrequency, fftSize)

nBins = 2;

harmonicFrequencies = zeros(nHarmonics, 1, 'like', peakLocations);
harmonicBins = zeros(nHarmonics, 1, 'like', peakLocations);
harmonicIdx = zeros(nHarmonics, 1, 'like', peakLocations);

% MATLAB indexing starts at one, so we need to remove 1 from the frequency
% location to get the actual frequency index/bin
fundamentalBin = fundamentalLocation - 1;
peakFreqs = peakLocations - 1;

for i = 1:numel(peakLocations)
    for harmonicNum = 1:nHarmonics
        harmonic = fundamentalBin * harmonicNum;

        freqDiff = abs(peakFreqs(i) - harmonic);
        if freqDiff <= nBins
            % the peak is within range of the theoretical harmonic frequency.
            if harmonicBins(harmonicNum) ~= 0
                % if a potential harmonic has already been found, check if the
                % new candidate is closer than the previous candidate. Keep the 
                % candidate that is closest to the theoretical harmonic.
                previousFreqDiff = abs(harmonicBins(harmonicNum) - harmonic);
                if freqDiff < previousFreqDiff
                    harmonicBins(harmonicNum) = peakFreqs(i);
                    harmonicIdx(harmonicNum) = i;
                end
            else
                % this is the first harmonic candidate we've found
                harmonicBins(harmonicNum) = peakFreqs(i);
                harmonicIdx(harmonicNum) = i;
            end
        end
    end
end

harmonicFrequencies = (avgSamplingFrequency / fftSize)  * harmonicBins;
