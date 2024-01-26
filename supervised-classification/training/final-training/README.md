# Final training

The final training is performed on the combined training and validation dataset. There are three different training functions, one for each type of classifier:

- feature engineering methods: `trainRowFeatureMethod`
- 1D CNNs: `trainRowDataMethod`
- 2D CNNs: `trainImageMethod`

The training functions take the classifier name as a string:
```matlab
trainRowFeatureMethod("AdaBoost");
trainImageMethod("CNN2d3Layer");
```

