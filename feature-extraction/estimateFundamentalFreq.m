function fundamental = estimateFundamentalFreq(psd)
% estimateFundamentalFreq estimate the fundamental frequency in a PSD using the
% harmonic product spectrum
%
%   fundamental = estimateFundamentalFreq(esd) estimates the fundamental
%   frequency in the one-sided energy spectral density magnitude, esd. 
%
%   See also harmonicProductSpectrum.

% SPDX-License-Identifier: BSD-3-Clause
arguments
    psd (:,:) {mustBeNumeric}
end

% TODO: nHarmonics should be an optional input parameter
hps = harmonicProductSpectrum(psd, 3);


[maximaIndicator] = islocalmax(hps,2,"FlatSelection","center","MaxNumExtrema",1);

[row, fundamentalLocTmp] = find(maximaIndicator);

[~,sortIdx] = sort(row);

fundamental = fundamentalLocTmp(sortIdx);

end
