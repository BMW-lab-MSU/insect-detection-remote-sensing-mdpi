function hps = harmonicProductSpectrum(spectrum, nSpectra)
% harmonicProductSpectrum compute the harmonic product spectrum of a one-sided
% spectrum or ESD
%
%   hps = harmonicProductSpectrum(spectrum, nSpectra) computes the haromnic
%   product spectrum. spectrum is a one-sided magnitude spectrum or one-sided
%   energy spectral density. nSpectra determines the the number of spectral
%   copies to use when computing the harmonic product spectrum.

% SPDX-License-Identifier: BSD-3-Clause
arguments
    % NOTE: spectrum must be wider than it is tall
    spectrum (:,:) {mustBeNumeric}
    nSpectra (1,1) {mustBeInteger}
end

% NOTE: the harmonic product spectrum sometimes finds the fundamental as an octave above the actual fundamental

rows = height(spectrum);
cols = floor(width(spectrum) / nSpectra);
spectra = zeros(nSpectra, rows, cols);
hps = zeros(rows, cols);

% Downsample the spectrum
for j = 1:nSpectra
    spectra(j, :, :) = spectrum(:, 1:j:(j * cols));
end

% The first dimension of the output of prod(spectra) is guaranteed to be a
% singleton dimension that we don't want; we use reshape to get rid of that
% singleton dimension and force the hps matrix to be rows x cols instead of
% 1 x rows x cols. Note that using `squeeze` here only works when rows !=
% 1; when rows == 1, squeeze returns a column vector (cols x 1) instead of
% a row vector (1 x cols).
hps = reshape(prod(spectra), [rows, cols]);
end