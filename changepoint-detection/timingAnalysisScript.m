%% Timing Analysis
% Runs through each of the algorithms three times and averages the time.

runtimeSummary = cell(2,6);

% Matlab Columns
tic
matlabChptsColsOriginal;
matlabChptsColsOriginal;
matlabChptsColsOriginal;
runtimeSummary{1,1} = toc/3;
runtimeSummary{2,1} = "Matlab Columns";

% Matlab Rows
tic
matlabChptsRowsOriginal;
matlabChptsRowsOriginal;
matlabChptsRowsOriginal;
runtimeSummary{1,2} = toc/3;
runtimeSummary{2,2} = "Matlab Rows";

% Matlab Both
tic
matlabChptsBothOriginal;
matlabChptsBothOriginal;
matlabChptsBothOriginal;
runtimeSummary{1,3} = toc/3;
runtimeSummary{2,3} = "Matlab Both";

% gfpop Columns
tic
gfpopColsOriginal;
gfpopColsOriginal;
gfpopColsOriginal;
runtimeSummary{1,4} = toc/3;
runtimeSummary{2,4} = "gfpop Columns";

% gfpop Rows
tic
gfpopRowsOriginal;
gfpopRowsOriginal;
gfpopRowsOriginal;
runtimeSummary{1,5} = toc/3;
runtimeSummary{2,5} = "gfpop Rows";

% gfpop Both
tic
gfpopBothOriginal;
gfpopBothOriginal;
gfpopBothOriginal;
runtimeSummary{1,6} = toc/3;
runtimeSummary{2,6} = "gfpop Both";

save("../../results/changepoint-results/runtimes/changepointRuntimeSummary","runtimeSummary","-v7.3");
