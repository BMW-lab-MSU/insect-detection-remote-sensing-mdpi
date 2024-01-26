classdef (Abstract) DeepLearningClassifier < Classifier
% DeepLearningClassifier Abstract base class for classifiers from the Deep Learning Toolbox
%
%   See also Classifier, DeepLearning1dClassifier, DeepLearning2dClassifier

% SPDX-License-Identifier: BSD-3-Clause
    
    properties (SetAccess=protected, GetAccess=public)
        % Layers array for the Deep Learning Toolbox
        Layers
        Model
        Hyperparams
        UseGPU=true
    end

    properties (Abstract,Access=protected)
        % Model-specific hyperparameters
        Params
        % Training parameters
        TrainingParams
        % Training options object from the trainingOptions function
        TrainingOptions
    end


    methods
        function hyperparams = get.Hyperparams(obj)
            hyperparams = mergeStructs(obj.Params,obj.TrainingParams);
        end

        function [labels,scores] = predict(obj,data)
            formattedData = obj.formatData(data);

            [labels,scores] = classify(obj.Model,formattedData);
        end

        function fit(obj,trainingData,trainingLabels,opts)
        % FIT Train the classifier
        %
        %   FIT(trainingData,trainingLabels) trains the classifier using
        %   trainingData and trainingLabels. trainingData is a cell array of
        %   matrices, where each cell corresponds to an image. trainingLabels'
        %   data structure depends on which concrete class is being used; for
        %   1D deep learning classifiers, trainingLabels is a cell array of
        %   label vectors. For 2D deep learning classifiers, trainingLabels is
        %   a vector of labels.
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
                if obj.UseGPU
                    gpurng(opts.Seed,"Threefry");
                end
            end

            formattedData = obj.formatData(trainingData);
            labels = obj.formatLabels(trainingLabels);

            obj.Model = trainNetwork(formattedData,labels,obj.Layers,obj.TrainingOptions);
        end
    end

    methods (Static,Access=protected)
        function params = createCostMatrix(params)
        % createCostMatrix Format cost matrix for the Deep Learning Toolbox
        %
        %   costMatrix = createCostMatrix(falseNegativeCost) formats a cost
        %   matrix for the Deep Learning Toolbox using falseNegativeCost.
        %
        %   The Deep Learning Toolbox expects the cost to be formatted as a
        %   normalized array of [falsePositiveCost falseNegativeCost].

            % Our constructors take only the false negative cost because we
            % can't have the full cost matrix be an optimizableVariable for
            % bayesopt. Create the cost matrix and remove the false negative
            % cost field so the trainNetwork function is happy. If the false
            % negative cost is empty, just keep the cost as is (either the
            % default value or whatever the caller passed in).

            % TODO: we should add a warning if both FalseNegativeCost and Cost
            % were passed in, if possible.
            if ~isempty(params.FalseNegativeCost)
                cost = [1,params.FalseNegativeCost];
                cost = cost / mean(cost);
                params.Cost = cost;
            end
            
            params = rmfield(params, "FalseNegativeCost");
        end
    end

end
