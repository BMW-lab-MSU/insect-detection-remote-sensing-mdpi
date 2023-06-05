function fundamental = estimateFundamentalFreq(psd, opts)
% estimateFundamentalFreq estimate the fundamental frequency in a PSD using the
% harmonic product spectrum
%
%   fundamental = estimateFundamentalFreq(psd) estimates the fundamental
%   frequency in the one-sided power spectral density magnitude, psd. 
%
%   See also harmonicProductSpectrum.

% SPDX-License-Identifier: BSD-3-Clause
arguments
    psd (:,:) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
end

fundamental = zeros(height(psd), 1);

hps = harmonicProductSpectrum(psd, 3);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

parfor (i = 1:height(psd), nWorkers)
    [~, fundamentalTmp] = findpeaks(hps(i,:), 'NPeaks', 1, ...
        'SortStr', 'descend');
    
    % if we don't find a fundamental frequency, then we keep it set at 0.
    if ~isempty(fundamentalTmp)
        fundamental(i) = fundamentalTmp;
    end
end

end