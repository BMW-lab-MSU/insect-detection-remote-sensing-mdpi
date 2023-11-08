% SPDX-License-Identifier: BSD-3-Clause
function createDataSamplingGrid

beehiveDataSetup;

% Setup undersampling and augmentation ranges
params.UndersamplingRatio = [0 0.25 0.5 0.75];
params.NSyntheticInsect = round([0,logspace(0,log10(100),3)]);

samplingGrid = formatGridSearchParams(params);

save(trainingDataDir + filesep + "samplingGridRowBased", 'samplingGrid');

end
