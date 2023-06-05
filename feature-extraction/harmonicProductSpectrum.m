function hps = harmonicProductSpectrum(spectrum, nSpectra)
% harmonicProductSpectrum compute the harmonic product spectrum of a one-sided
% spectrum or PSD
%
%   hps = harmonicProductSpectrum(spectrum, nSpectra) computes the haromnic
%   product spectrum. spectrum is a one-sided magnitude spectrum or one-sided
%   power spectral density. nSpectra determines the the number of spectral
%   copies to use when computing the harmonic product spectrum.

% SPDX-License-Identifier: BSD-3-Clause

rows = height(spectrum);
cols = floor(width(spectrum) / nSpectra);
spectra = zeros(nSpectra, rows, cols);
hps = zeros(rows, cols);

% Downsample the spectrum
for j = 1:nSpectra
    spectra(j, :, :) = spectrum(:, 1:j:(j * cols));
end

hps = squeeze(prod(spectra));
end