classdef StatsNeuralNetwork < StatsToolboxClassifier
% StatsNeuralNetwork Wrapper for neural network classifiers from the Stats Toolbox
%
%   StatsNeuralNetwork Methods:
%       StatsNeuralNetwork - Constructor
%
%   See the html docuemtnation or the Classifier help text for documentation
%   on the other methods.
%
%   See also StatsToolboxClassifier, Classifier, fitcnet, ClassificationNeuralNetwork

% SPDX-License-Identifier: BSD-3-Clause

    properties (SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
        % Whether to use a GPU or not.
        % As of 2023a, the Stats Toolbox neural networks don't have GPU support.
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

            formattedParams = formatOptimizableParams@Classifier(optimizableParams);

            fieldNames = fields(formattedParams);

            nLayers = nnz(contains(fieldNames,"LayerSize"));

            layerSizeFieldName = fieldNames(contains(fieldNames,"LayerSize"));

            % If the layer size field name is LayerSizes, then we don't have
            % to format the parameters at all because LayerSizes is the field
            % name that the constructor expects
            if nLayers == 1 && strcmp(layerSizeFieldName,"LayerSizes")
                return
            end

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
        function fit(obj,trainingData,trainingLabels,opts)
        % FIT Train the classifier
        %
        %   FIT(trainingData,trainingLabels) trains the neural network using
        %   trainingData and trainingLabels. trainingData is a cell array of
        %   matrices or tables. trainingLabels is a cell array of label vectors.
        %
        %   Name-Value Arguments:
        %       Reproducible    - Whether or not to seed the random number
        %                         generator to make the training more
        %                         reproducible.
        %       Seed            - The value used to seed the random number
        %                         generator.
            arguments
                obj
                trainingData
                trainingLabels
                opts.Reproducible = true
                opts.Seed (1,1) uint32 {mustBeNonnegative} = 0
            end

            if opts.Reproducible
                rng(opts.Seed,"twister");
            end

            data = StatsNeuralNetwork.formatData(trainingData);
            labels = StatsNeuralNetwork.formatLabels(trainingLabels);

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            params = namedargs2cell(obj.Hyperparams);

            obj.Model = compact(fitcnet(data, labels, params{:}));
            
        end

        function obj = StatsNeuralNetwork(params)
        % StatsNeuralNetwork Construct a StatsNeuralNetwork object
        %
        %   Name-Value Arguments:
        %       LayerSizes          - Array of hidden layer sizes. When using
        %                             one hidden layer, this can be a scalar.
        %       Standardize         - Whether or not to standardize input data.
        %       Lambda              - Lambda regularization value.
        %       Acitvations         - Which activiation function to use.
        %                             Options are relu, tanh, sigmoid, and none.
        %       FalseNegativeCost   - False negative cost in the cost matrix.
        %                             This overrides the Cost parameter.
        %       Cost                - Cost matrix.
        %       ScoreTranform       - Which score transform to perform.
        %
        %   To see the default parameters, run
        %   StatsNeuralNetwork.getDefaultParameters()
        %
        %   See also fitcnet
            arguments
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
