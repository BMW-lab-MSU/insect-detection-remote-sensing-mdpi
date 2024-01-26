# Classifier classes

This folder contains classes that implement a unified interface for classifiers in the Statistic/Machine Learning Toolbox and the Deep Learning Toolbox.

## Method descriptions
| method                | description |
|-----------------------|-------------|
|`fit`                     | Train the classifier|
|`predict`                 | Predict the labels of new data|
|`getDefaultParameters`    | Get the classifier's default parameters|
|`formatData`              | Format the data in the format that the underlying classifier needs.|
|`formatLabels`            | Format the labels in the format that the underlying classifier needs.|
|`formatOptimizableParams` | Format bayesopt OptimizableVariables to be compatible with the classifier's constructor. |
|`createCostMatrix`        | Create the cost matrix in the format that the classifier needs.|

See the built-in help-text and html documentation using `help` and `doc`.

## Class diagram
The diagram below illustrates the class hiearchy.

```mermaid
classDiagram
    class Classifier{
        Model
        Hyperparams
        UseGPU
        fit(trainingData,trainingLabels)
        predict(data)
        getDefaultParameters()
        formatData(data)
        formatLabel(labels)
        formatOptimizableParams(optimizableParams)
        createCostMatrix(falseNegativeCost)
    } 

    class StatsToolboxClassifier
    class DeepLearningClassifier{
        Layers
        Params
        TrainingParams
        TrainingOptions
    }
    class TreeEnsemble{
        TreeParams
        EnsembleParams
        MethodParams
        AggregationMethod
    }
    class AdaBoost
    class RUSBoost
    class DeepLearning1dClassifier
    class DeepLearning2dClassifier
    class CNN1d
    class CNN2d
    class StatsNeuralNetwork
    class SVM

    Classifier <|-- DeepLearningClassifier
    DeepLearningClassifier <|-- DeepLearning1dClassifier
    DeepLearningClassifier <|-- DeepLearning2dClassifier
    DeepLearning1dClassifier <|-- CNN1d
    DeepLearning2dClassifier <|-- CNN2d

    Classifier <|-- StatsToolboxClassifier
    StatsToolboxClassifier <|-- SVM
    StatsToolboxClassifier <|-- TreeEnsemble
    StatsToolboxClassifier <|-- StatsNeuralNetwork

    TreeEnsemble <|-- AdaBoost
    TreeEnsemble <|-- RUSBoost


```