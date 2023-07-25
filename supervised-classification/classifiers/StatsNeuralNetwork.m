classdef StatsNeuralNetwork < StatsToolboxClassifier

    properties (SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
        UseGPU = false
    end

    properties (SetAccess = immutable, GetAccess = public)
        Name
    end

    methods (Static)
        function params = getDefaultParameters()
            params.LayerSizes = 10;
            params.Standardize = true;
            params.Lambda = 0;
            params.Activations = "relu";
            params.Cost = ones(2) - eye(2);
            params.ScoreTransform = "none";
        end

        function formattedParams = formatOptimizableParams(optimizableParams)
            if isa(optimizableParams,"table")
                formattedParams = table2struct(optimizableParams);
            else
                formattedParams = optimizableParams;
            end

            fieldNames = fields(formattedParams);

            nLayers = nnz(contains(fieldNames,"LayerSize"));

            layerSizes = zeros(1,nLayers);

            for layerNum = 1:nLayers
                field = "LayerSize" + layerNum;

                % Add the layer size into the layers array
                layerSizes(layerNum) = formattedParams.(field);

                % Remove LayerSize<layerNum> field from parameters structure
                formattedParams = rmfield(formattedParams,field);
            end

            formattedParams.LayerSizes = layerSizes;
        end
    end

    methods
        function fit(obj,trainingData,trainingLabels)

            data = StatsNeuralNetwork.formatData(trainingData);
            labels = StatsNeuralNetwork.formatLabels(trainingLabels);

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            params = namedargs2cell(obj.Hyperparams);

            obj.Model = compact(fitcnet(data, labels, params{:}));
            
        end

        function obj = StatsNeuralNetwork(params)
            arguments
                % TODO: additional argument validation
                % set default hyperparameters; these default values
                % are the same as MATLAB's default values as of 2023a.
                % This doesn't include  all possible parameters; just the ones
                % that are commonly used and/or optimizable in fitcensemble.
                params.LayerSizes = 10
                params.Standardize = true
                params.Lambda = 0
                params.Activations (1,1) string {mustBeMember(params.Activations,["relu","tanh","sigmoid","none"])} = "relu"
                params.FalseNegativeCost = []
                params.Cost = ones(2) - eye(2)
                params.ScoreTransform = "none"
            end

            nLayers = numel(params.LayerSizes);
            obj.Name = "StatsNeuralNetwork" + nLayers + "Layer";

            params = obj.createCostMatrix(params);

            obj.Hyperparams = params;
        end
    end
    
end