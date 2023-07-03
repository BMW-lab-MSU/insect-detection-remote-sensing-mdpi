% SPDX-License-Identifier: BSD-3-Clause

% Setup undersampling and augmentation ranges
params.UndersamplingRatio = [0 0.2 0.4 0.6 0.8];
params.NSyntheticInsect = round([0,logspace(0,log10(100),3)]);

samplingGrid = formatGridSearchParams(params);

save(trainingDataDir + filesep + "samplingGridRowBased", 'samplingGrid');
