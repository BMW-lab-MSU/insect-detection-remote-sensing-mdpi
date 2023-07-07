classdef (Abstract) Classifier < handle

    properties (Abstract, SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
        UseGPU
    end
    
    methods (Abstract)
        fit(obj,trainingData,trainingLabels)
        [labels,scores] = predict(obj,data)
    end

    methods (Abstract,Static)
        params = getDefaultParameters()
        formattedData = formatData(data)
        formattedLabels = formatLabels(labels)
    end


    % TODO: we could add a private method here that handles the if obj.UseGPU stuff

end
