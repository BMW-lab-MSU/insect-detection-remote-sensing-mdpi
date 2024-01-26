# Figure creation
This folder contains the code used to create the figures in the paper.

- Figure 1: `insectDetectionIntuitionFigures` creates the plots. Additional graphics and manipulation were created in Adobe Illustrator
- Figure 5: `createBeeExamplesFigures`
- Figure 7: `createTransitAndFrequencyHistograms`
- Figure 8: `createBeforeAndAfterThresholdingFigure`
- Figure 9: `featureRankingFig`. This requires computing mutual information using [`computeMutualInfo.py`](../dataset-analysis/computeMutualInfo.py) before creating the figure.
- Figure 11: `featurePairwiseScatterPlot`. Some additional manipulation was done using Inkscape.
- Figure 12: `createFrequencyHistograms`
- Figure 13: `classificationVsConfidence`. [`analyzeConfidenceRatingEffects.m`](../results-analysis/analyzeConfidenceRatingEffects.m) must be run before creating this figure.
- Figure 14: `createLabelDiscussionFigure`. This figure might not always be the same because the classifier results are not entirely deterministic.