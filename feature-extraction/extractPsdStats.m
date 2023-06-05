function features = extractPsdStats(psd)
% extractPsdStats extract descriptive statistics from the PSD
%
%   features = extractHarmonicFeatures(psd, nHarmonics) extracts features from
%   the power spectral density, psd. psd is a one-sided power spectral density
%   magnitude, i.e. abs(fft(X).^2). features is a table of the extracted 
%   features.
%
%   The extracted statistics are:
%       'MeanPsd'       - The mean of the PSD
%       'StdPsd'        - The standard deviation of the PSD
%       'MedianPsd'     - The median of the PSD
%       'MadPsd'        - The median absolute deviation of the PSD
%       'SkewnessPsd'   - Zero-mean skewness of the PSD   
%       'KurtosisPsd'   - Zero-mean kurtosis of the PSD     

% SPDX-License-Identifier: BSD-3-Clause

avg_psd = mean(psd, 2);
std_psd = std(psd, 0, 2);
median_psd = median(psd, 2);
mad_psd = mad(psd, 1, 2);
skew_psd = skewness(psd, 1, 2);
skew_psd = skew_psd - mean(skew_psd);
kurtosis_psd = kurtosis(psd, 1, 2);
kurtosis_psd = kurtosis_psd - mean(kurtosis_psd);

% compute the index at which 99% of energy is contained
% energypct = cumsum(psd,2)./sum(psd,2);
% energy99pct = zeros(height(psd), 1);
% energy99pct_no_dc = zeros(height(psd), 1);

% for row = 1:height(psd)
%     % ignore dc component because it contains basically all the energy
%     % NOTE: actually, ignoring the dc component might not be important;
%     %       in this case, removing the dc component only makes a difference
%     %       of 1 index at most
%     energy99pct(row) = find(energypct(row,1:end) >= 0.99, 1);
%     energy99pct_no_dc(row) = find(energypct(row,2:end) >= 0.99, 1);
% end

features = table;
features.MeanPsd = avg_psd;
features.StdPsd = std_psd;
features.MedianPsd = median_psd;
features.MadPsd = mad_psd;
features.SkewnessPsd = skew_psd;
features.KurtosisPsd = kurtosis_psd;
% features.Bin99PctEnergy = energy99pct;

end