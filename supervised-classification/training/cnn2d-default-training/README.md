# 2D CNN default training

We do not perform any data sampling for the 2D CNNs. Since the hyperparameter tuning doesn't consider the default hyperparameters, we want to train a model with the default hyperparameters, just in case the default parameters perform best.

The default 2D CNNS can be trained with the `trainCNN2dManualParams` function.

For example, here's the code used to train the default 3-layer 2D CNN:
```matlab
p.FilterSize=[16,2;,16,2;16,2];
p.Nfilters=[20,20,20];
trainCNN2dManualParams(@CNN2d,UseGPU=true,ClassifierParams=p) 
```