classdef (Abstract) Classifier < HandleHiddenMethods
% Classifier Abstract base class for classifiers
%
% This is the abstract base class which provides a unified interface
% for classifiers from the Stats/ML Toolbox and the Deep Learning Toolbox.
%   
% Classifier Properties:
%     Model       - The underlying model object from the relevant toolbox.
%     Hyperparams - Structure of the classifier's hyperparameters
%     UseGPU      - Whether or not the classifier will use the GPU.
%
% Classifier Methods:
%     fit                     - Train the classifier
%     predict                 - Predict the labels of new data
%     getDefaultParameters    - Get the classifier's default parameters
%     formatData              - Format the data in the format that the
%                               underlying classifier needs.
%     formatLabels            - Format the labels in the format that the
%                               underlying classifier needs.
%     formatOptimizableParams - Format bayesopt OptimizableVariables to be
%                               compatible with the classifier's constructor. 
%     createCostMatrix        - Create the cost matrix in the format that the
%                               underlying classifier needs.

% SPDX-License-Identifier: BSD-3-Clause

    properties (Abstract, SetAccess = protected, GetAccess = public)
        % The underlying model from the toolbox
        Model
        % Structure of hyperparameters
        Hyperparams
        % Whether or not to use a GPU, if avaiable
        UseGPU
    end

    properties (Abstract, SetAccess = immutable, GetAccess = public)
        % The classifier's name
        Name
    end

    methods (Hidden)

        function lh = addlistener(varargin)
            lh = addlistener@handle(varargin{:});
        end
    end
    
    methods (Abstract)
        % NOTE: the method documentation for abstract methods is above the
        % method name to make the documentation show up in help/doc. Matlab
        % ordinarily doesn't show documentation for abstract methods.
        % This workaround works as of 2023a.
        % See https://stackoverflow.com/a/13402878 for the original source.

        % FIT Train the classifier
        %
        %   FIT(trainingData,trainingLabels) trains the classifier using
        %   trainingData and trainingLabels. trainingData is a cell array of
        %   matrices, where each cell corresponds to an image. trainingLabels'
        %   data structure depends on which concrete class is being used.
        %
        %   Name-Value Arguments:
        %       Reproducible    - Whether or not to seed the random number
        %                         generator to make the training more
        %                         reproducible.
        %       Seed            - The value used to seed the random number
        %                         generator.
        fit(obj,trainingData,trainingLabels,opts)

        % PREDICT Predict labels on new data
        %
        %   [labels,scores] = PREDICT(data) predicts class labels and scores
        %   for data. data is a cell array of matrices, where each cell
        %   corresponds to an image.
        [labels,scores] = predict(obj,data)
    end

    methods (Abstract,Static)
        % getDefaultParameters Get the classifier's default hyperparameters.
        %
        %   params = getDefaultParmaeters() returns the classifier's default
        %   hyperparameters.
        params = getDefaultParameters()

        % formatData Format the data how the underlying classifier needs it.
        %
        %   formattedData = formatData(data)
        %
        %   This method is generally called from within other class methods,
        %   but may be called outside of the class.
        formattedData = formatData(data)

        % formatLabels Format the labels how the underlying classifier needs it.
        %
        %   formattedLabels = formatLabels(labels)
        %
        %   This method is generally called from within other class methods,
        %   but may be called outside of the class.
        formattedLabels = formatLabels(labels)
    end

    methods (Static)
        function formattedParams = formatOptimizableParams(optimizableParams)
        % formatOptimizableParams Format OptimizableVariables for compatibility.
        %
        %   formattedParams = formatOptimizableParams(optimizableParams)
        %
        %   When performing hyperparameter tuning using bayesopt, bayesopt
        %   passes a table of OptimizableVariables to the objective function.
        %   These parameters are not in a format that the classifier's
        %   constructor can directly use, thus this method formats the
        %   OptimizableVariable parameters to be compatible with the
        %   classifier's constructor.

            % bayesopt uses tables instead of structs, but we need to use
            % structs so we can convert Name-Value pairs into a cell array
            % that we can pass to the classifier constructor
            if isa(optimizableParams,"table")
                formattedParams = table2struct(optimizableParams);
            else
                formattedParams = optimizableParams;
            end
        end
    end

    methods (Abstract,Static,Access=protected)
        % createCostMatrix Format cost matrix for the underlying classifier
        %
        %   costMatrix = createCostMatrix(falseNegativeCost) formats a cost
        %   matrix for the underlying classifier type using falseNegativeCost.
        %
        %   Different classifiers from the Stats/ML and Deep Learning toolbox
        %   specify cost matrices in different ways. This method handles that
        %   formatting so we can always just specify the false negative cost.
        costMatrix = createCostMatrix(falseNegativeCost)
    end

    % TODO: we could add a private method here that handles the if obj.UseGPU stuff

end
