function fundamental = estimateFundamentalFreq(esd, opts)
% estimateFundamentalFreq estimate the fundamental frequency in a ESD using the
% harmonic product spectrum
%
%   fundamental = estimateFundamentalFreq(esd) estimates the fundamental
%   frequency in the one-sided energy spectral density magnitude, esd. 
%
%   See also harmonicProductSpectrum.

% SPDX-License-Identifier: BSD-3-Clause
arguments
    esd (:,:) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
end

fundamental = zeros(height(esd), 1);

hps = harmonicProductSpectrum(esd, 3);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

parfor (i = 1:height(esd), nWorkers)
    [~, fundamentalTmp] = findpeaks(hps(i,:), 'NPeaks', 1, ...
        'SortStr', 'descend');
    
    % if we don't find a fundamental frequency, then we keep it set at 0.
    if ~isempty(fundamentalTmp)
        fundamental(i) = fundamentalTmp;
    end
end

end