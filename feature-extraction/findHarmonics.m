function [harmonicLocations, harmonicIdx] = findHarmonics(peakLocations, fundamentalLocation, nHarmonics)

nBins = 2;

harmonicLocations = zeros(nHarmonics, 1, 'like', peakLocations);
harmonicFreqs = zeros(nHarmonics, 1, 'like', peakLocations);
harmonicIdx = zeros(nHarmonics, 1, 'like', peakLocations);

% MATLAB indexing starts at one, so we need to remove 1 from the frequency
% location to get the actual frequency index/bin
fundamentalFreq = fundamentalLocation - 1;
peakFreqs = peakLocations - 1;

for i = 1:numel(peakLocations)
    for harmonicNum = 1:nHarmonics
        harmonic = fundamentalFreq * harmonicNum;

        freqDiff = abs(peakFreqs(i) - harmonic);
        if freqDiff <= nBins
            % the peak is within range of the theoretical harmonic frequency.
            if harmonicFreqs(harmonicNum) ~= 0
                % if a potential harmonic has already been found, check if the
                % new candidate is closer than the previous candidate. Keep the 
                % candidate that is closest to the theoretical harmonic.
                previousFreqDiff = abs(harmonicFreqs(harmonicNum) - harmonic);
                if freqDiff < previousFreqDiff
                    harmonicFreqs(harmonicNum) = peakFreqs(i);
                    harmonicIdx(harmonicNum) = i;
                end
            else
                % this is the first harmonic candidate we've found
                harmonicFreqs(harmonicNum) = peakFreqs(i);
                harmonicIdx(harmonicNum) = i;
            end
        end
    end
end

harmonicLocations = harmonicFreqs + 1;

% When we don't find a particular harmonic, e.g. harmonic 2 because the
% the harmonics are all odd, we want to return a 0 (or a NaN) to indicate that 
% no harmonic was found at that location.
harmonicLocations(harmonicLocations == 1) = 0;

    
