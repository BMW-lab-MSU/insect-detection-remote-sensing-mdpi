function features = extractEsdStats(esd)
% extractEsdStats extract descriptive statistics from the ESD
%
%   features = extractHarmonicFeatures(esd, nHarmonics) extracts features from
%   the energy spectral density, esd. esd is a one-sided energy spectral density
%   magnitude, i.e. abs(fft(X).^2). features is a table of the extracted 
%   features.
%
%   The extracted statistics are:
%       'MeanEsd'       - The mean of the ESD
%       'StdEsd'        - The standard deviation of the ESD
%       'MedianEsd'     - The median of the ESD
%       'MadEsd'        - The median absolute deviation of the ESD
%       'SkewnessEsd'   - Zero-mean skewness of the ESD   
%       'KurtosisEsd'   - Zero-mean kurtosis of the ESD     

% SPDX-License-Identifier: BSD-3-Clause

avgEsd = mean(esd, 2);
stdEsd = std(esd, 0, 2);
medianEsd = median(esd, 2);
madEsd = mad(esd, 1, 2);
skewEsd = skewness(esd, 1, 2);
skewEsd = skewEsd - mean(skewEsd);
kurtosisEsd = kurtosis(esd, 1, 2);
kurtosisEsd = kurtosisEsd - mean(kurtosisEsd);

% compute the index at which 99% of energy is contained
% energypct = cumsum(esd,2)./sum(esd,2);
% energy99pct = zeros(height(esd), 1);
% energy99pct_no_dc = zeros(height(esd), 1);

% for row = 1:height(esd)
%     % ignore dc component because it contains basically all the energy
%     % NOTE: actually, ignoring the dc component might not be important;
%     %       in this case, removing the dc component only makes a difference
%     %       of 1 index at most
%     energy99pct(row) = find(energypct(row,1:end) >= 0.99, 1);
%     energy99pct_no_dc(row) = find(energypct(row,2:end) >= 0.99, 1);
% end

features = table;
features.MeanEsd = avgEsd;
features.StdEsd = stdEsd;
features.MedianEsd = medianEsd;
features.MadEsd = madEsd;
features.SkewnessEsd = skewEsd;
features.KurtosisEsd = kurtosisEsd;
% features.Bin99PctEnergy = energy99pct;

end