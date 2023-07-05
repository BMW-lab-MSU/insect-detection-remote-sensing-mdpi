function fundamental = estimateFundamentalFreq(esd)
% estimateFundamentalFreq estimate the fundamental frequency in a PSD using the
% harmonic product spectrum
%
%   fundamental = estimateFundamentalFreq(esd) estimates the fundamental
%   frequency in the one-sided energy spectral density magnitude, esd. 
%
%   See also harmonicProductSpectrum.

% SPDX-License-Identifier: BSD-3-Clause
arguments
    esd (:,:) {mustBeNumeric}
end

% TODO: nHarmonics should be an optional input parameter
hps = harmonicProductSpectrum(esd, 3);


[maximaIndicator] = islocalmax(hps,2,"FlatSelection","center","MaxNumExtrema",1);

fundamental = zeros(height(esd),1,"like",esd);

for i = 1:numel(fundamental)
    idx = find(maximaIndicator(i,:));
    if ~isempty(idx)
        fundamental(i) = idx;
    else
        fundamental(i) = 0;
    end
end

end
