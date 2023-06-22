function features = extractTFFeatures(X, opts)
arguments
    X (:,:) {mustBeNumeric}
    opts.UseParallel = false
end

[rows,columns] = size(X);

% TODO: camelCase
maxMean = zeros(rows,1,'like',X);
maxStd = zeros(rows,1,'like',X);
avgMean = zeros(rows,1,'like',X);
avgSkewness = zeros(rows,1,'like',X);
maxPeak = zeros(rows,1,'like',X);
maxDiff = zeros(rows,1,'like',X);
brkUp = zeros(rows,1,'like',X);

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

    maxMean(i) = max(mean(cwavelet,2));
    maxStd(i) = max(std(cwavelet,0,2));
    avgMean(i) = mean(mean(cwavelet,2));
    avgSkewness(i) = mean(skewness(cwavelet,1,2));
    maxPeak(i) = max(max(cwavelet));
    maxDiff(i) = max(max(diff(cwavelet)));

end

features = table;
features.WaveletMaxMean = maxMean;
features.WaveletMaxStd = maxStd;
features.WaveletAvgMean = avgMean;
features.WaveletAvgSkewness = avgSkewness;
features.WaveletMaxPeak = maxPeak;
features.WaveletMaxDiff = maxDiff;

end
