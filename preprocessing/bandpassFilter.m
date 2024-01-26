function filtered = bandpassFilter(x,order,passband,fs)
% bandpassFilter filter data using a Butterworth filter
%
%   filtered = bandpassFilter(x,order,passband,fs) filters the data in x using
%   a Butterworth filter. order specifies the order of the filter, passband is 
%   a 1-by-2 vector of passband frequencies, and fs is the data's sampling rate.
%
%   See also butter, zp2sos, sosfilt

% SPDX-License-Identifier: BSD-3-Clause

arguments
    x {mustBeNumeric}
    order (1,1) {mustBeInteger}
    passband (1,2) {mustBeNumeric}
    fs (1,1) {mustBeNumeric}
end

% Design the butterworth filter and use zero-pole-gain format for stability reasons
% https://www.mathworks.com/help/signal/ref/butter.html#bucsflt
[z,p,k] = butter(order, passband/(fs/2));

% Convert filter into second-order-sections for stability
sos = zp2sos(z,p,k);

% Transpose the data. MATLAB filters columns, but we need to filter rows.
d = x.';

tmp = sosfilt(sos,d);

% Transpose the data back to it's original orientation
filtered = tmp.';

end
