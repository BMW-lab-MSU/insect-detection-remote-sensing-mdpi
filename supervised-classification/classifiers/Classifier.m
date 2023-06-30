classdef (Abstract) Classifier < handle

    properties (Abstract, SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
    end
    
    methods (Abstract)
        fit(obj,trainingData,labels)
    end

    methods
        function [labels,scores] = predict(obj,newData)
            
            [labels,scores] = predict(obj.Model,newData);
        end
    end

end
