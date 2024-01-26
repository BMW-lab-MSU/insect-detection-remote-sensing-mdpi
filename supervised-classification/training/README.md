# Code for training supervised learning algorithms

There are three main parts of the training:
1. [Data sampling 📁](data-sampling) (row-based methods) or [default training 📁](cnn2d-default-training) (image-based methods)
2. [Hyperparameter tuning 📁](hyperparameter-tuning)
3. [Final training 📁](final-training)

See the individual folders for more information.

Everything except the final training uses [`validationObjFcn`](validationObjFcn.m) to do the actual training. `validationObjFcn` trains on the training dataset and tests on the validation data. The final training functions train on the combination of the training and validation data.
