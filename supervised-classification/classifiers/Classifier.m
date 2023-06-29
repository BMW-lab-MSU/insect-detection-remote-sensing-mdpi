classdef (Abstract) Classifier < handle

    properties (Abstract)
        model
        hyperparams
    end
    
    methods (Abstract)
        fit(obj,trainingData,labels)

        [labels,scores] = predict(obj,newData)
    end
end
