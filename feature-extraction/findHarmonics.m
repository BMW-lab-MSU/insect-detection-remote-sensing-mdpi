function [harmonicFrequencies, harmonicIdx] = findHarmonics(peakLocations, fundamentalLocation, nHarmonics, avgSamplingFrequency, fftSize, opts)
arguments
    peakLocations (1,:) {mustBeInteger}
    fundamentalLocation (1,1) {mustBeInteger}
    nHarmonics (1,1) {mustBeInteger}
    avgSamplingFrequency (1,1) {mustBeNumeric}
    fftSize (1,1) {mustBeInteger}
    opts.nBins {mustBeInteger} = 2;
end

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
        if freqDiff <= opts.nBins
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
