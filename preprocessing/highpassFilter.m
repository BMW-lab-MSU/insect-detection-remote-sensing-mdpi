function filtered = highpassFilter(x,order,cutoff,fs)

arguments
    x {mustBeNumeric}
    order (1,1) {mustBeInteger}
    cutoff (1,1) {mustBeNumeric}
    fs (1,1) {mustBeNumeric}
end

% Design the butterworth filter and use zero-pole-gain format for stability reasons
% https://www.mathworks.com/help/signal/ref/butter.html#bucsflt
[z,p,k] = butter(order, cutoff/(fs/2),"high");

% Convert filter into second-order-sections for stability
sos = zp2sos(z,p,k);

% Transpose the data. MATLAB filters columns, but we need to filter rows.
d = x.';

tmp = sosfilt(sos,d);

% Transpose the data back to it's original orientation
filtered = tmp.';

end
