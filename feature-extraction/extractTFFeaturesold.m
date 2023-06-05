function features = extractTFFeatures(X, opts)
arguments
    X (:,:) {mustBeNumeric}
    opts.UseParallel = false
end

[rows,columns] = size(X);
cwavelet = cell(rows,1);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

parfor(i = 1:rows, nWorkers)
    if(sum(X(i,:),2) ~= 0)
    cwavelet{i} = abs(cwt(X(i,:)).^2);
    else
        cwavelet{i} = zeros(1,1024);
    end
end
features = extractTFStats(cwavelet);
end
