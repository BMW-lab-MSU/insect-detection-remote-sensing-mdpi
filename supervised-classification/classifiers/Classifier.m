classdef (Abstract) Classifier < handle

% SPDX-License-Identifier: BSD-3-Clause

    properties (Abstract, SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
        UseGPU
    end

    properties (Abstract, SetAccess = immutable, GetAccess = public)
        Name
    end
    
    methods (Abstract)
        fit(obj,trainingData,trainingLabels,opts)
        [labels,scores] = predict(obj,data)
    end

    methods (Abstract,Static)
        params = getDefaultParameters()
        formattedData = formatData(data)
        formattedLabels = formatLabels(labels)
    end

    methods (Static)
        function formattedParams = formatOptimizableParams(optimizableParams)
            if isa(optimizableParams,"table")
                formattedParams = table2struct(optimizableParams);
            else
                formattedParams = optimizableParams;
            end
        end
    end

    methods (Abstract,Static,Access=protected)
        costMatrix = createCostMatrix(falseNegativeCost)
    end

    % TODO: we could add a private method here that handles the if obj.UseGPU stuff

end
