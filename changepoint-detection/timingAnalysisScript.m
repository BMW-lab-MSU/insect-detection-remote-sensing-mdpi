% SPDX-License-Identifier: BSD-3-Clause
%% Timing Analysis
% Runs through each of the algorithms three times and averages the time.

runtimeSummary = cell(2,6);

% Matlab Columns
tic
matlabChptsCols;
runtimeSummary{1,1} = toc;
runtimeSummary{2,1} = "Matlab Columns";
clearvars -except runtimeSummary

% Matlab Rows
tic
matlabChptsRows;
runtimeSummary{1,2} = toc;
runtimeSummary{2,2} = "Matlab Rows";
clearvars -except runtimeSummary

% Matlab Both
tic
matlabChptsBoth;
runtimeSummary{1,3} = toc;
runtimeSummary{2,3} = "Matlab Both";
clearvars -except runtimeSummary

% gfpop Columns
tic
gfpopCols;
runtimeSummary{1,4} = toc;
runtimeSummary{2,4} = "gfpop Columns";
clearvars -except runtimeSummary

% gfpop Rows
tic
gfpopRows;
runtimeSummary{1,5} = toc;
runtimeSummary{2,5} = "gfpop Rows";
clearvars -except runtimeSummary

% gfpop Both
tic
gfpopBoth;
runtimeSummary{1,6} = toc;
runtimeSummary{2,6} = "gfpop Both";
clearvars -except runtimeSummary

save(changepointResultsDir + filesep + "runtimes" + filesep + "changepointRuntimeSummary","runtimeSummary","-v7.3");
