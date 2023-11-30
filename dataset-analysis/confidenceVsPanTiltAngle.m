% SPDX-License-Identifier: BSD-3-Clause
beehiveDataSetup;

load(combinedDataDir + filesep + "2022-06-combined","juneRowConfidence","juneMetadata","juneImgLabels");
load(combinedDataDir + filesep + "2022-07-combined","julyRowConfidence","julyMetadata","julyImgLabels");

%%
pan = [horzcat(juneMetadata.Pan), horzcat(julyMetadata.Pan)];
tilt = [horzcat(juneMetadata.Tilt), horzcat(julyMetadata.Tilt)];

confidence = cellfun(@(c) nonzeros(c),[juneRowConfidence, julyRowConfidence], UniformOutput=false);

% Select only the images that have bees
beeIdx = find(cellfun(@(c) ~isempty(c), confidence));
pan = pan(beeIdx);
tilt = tilt(beeIdx);
confidence = confidence(beeIdx);

groups = findgroups(pan,tilt);

for conf = 1:4
    nBeeLabelsByConfidence(conf,:) = splitapply(@(x) ...
        numel(find(vertcat(x{:}) == conf)),confidence,groups);
end

uniquePanAngles = splitapply(@unique,pan,groups);
uniqueTiltAngles = splitapply(@unique,tilt,groups);

%%
bar(nBeeLabelsByConfidence','grouped')

