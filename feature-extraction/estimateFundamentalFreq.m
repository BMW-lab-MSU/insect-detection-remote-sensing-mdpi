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



% TODO: nHarmonics should be an optional input parameter
hps = harmonicProductSpectrum(psd, 3);

% if opts.UseParallel
%     nWorkers = gcp('nocreate').NumWorkers;
% else
%     nWorkers = 0;
% end


% TODO: don't hardcode the optional parameters, or at least come up with
% reasonable values
% NOTE: islocalmax appears to be ~11 times faster than findpeaks when not
% using a parallel pool. When using a parallel pool of 8 workers for
% findpeaks, islocalmax is ~1.89 times faster. Note that islocalmax is
% always single-threaded. islocalmax could be parallelized as well if I
% split the data up into nWorkers separate sections, which should achieve a
% near-linear speedup, I think. Just some things to think about.
[maximaIndicator] = islocalmax(hps,2,"FlatSelection","center","MaxNumExtrema",1,"MinProminence",1,"MinSeparation",5);

[row, fundamentalLocTmp] = find(maximaIndicator);

[~,sortIdx] = sort(row);

fundamental = fundamentalLocTmp(sortIdx);

% parfor (i = 1:height(psd), nWorkers)
%     [~, fundamentalTmp] = findpeaks(hps(i,:), 'NPeaks', 1, ...
%         'SortStr', 'descend');
% 
%     % if we don't find a fundamental frequency, then we keep it set at 0.
%     if ~isempty(fundamentalTmp)
%         fundamental(i) = fundamentalTmp;
%     end
% end

end