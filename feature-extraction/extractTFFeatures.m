function features = extractTFFeatures(X, opts)
arguments
    X (:,:) {mustBeNumeric}
    opts.UseParallel = false
end

[rows,columns] = size(X);

% TODO: camelCase
max_mean = zeros(rows,1,'like',X);
max_std = zeros(rows,1,'like',X);
avg_mean = zeros(rows,1,'like',X);
avg_skewness = zeros(rows,1,'like',X);
max_peak = zeros(rows,1,'like',X);
max_diff = zeros(rows,1,'like',X);
brk_up = zeros(rows,1,'like',X);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

% get better performance by using a single filterbank for each loop
% iteration instead of one per iteration; this was suggested by MATLAB's
% "Tips" seciton of the cwt documentation
waveletFilterbank = cwtfilterbank;

parfor(i = 1:rows, nWorkers)
    if(sum(X(i,:),2) ~= 0)
        cwavelet = abs(wt(waveletFilterbank,X(i,:)).^2);
    else
        cwavelet = zeros(1,1024);
    end

    % features = extractTFStats(cwavelet);

    max_mean(i) = max(mean(cwavelet,2));
    max_std(i) = max(std(cwavelet,0,2));
    avg_mean(i) = mean(mean(cwavelet,2));
    avg_skewness(i) = mean(skewness(cwavelet,1,2));
    max_peak(i) = max(max(cwavelet));
    max_diff(i) = max(max(diff(cwavelet)));

end

features = table;
features.max_mean = max_mean;
features.max_std = max_std;
features.avg_mean = avg_mean;
features.avg_skewness = avg_skewness;
features.max_peak = max_peak;
features.max_diff = max_diff;

end
