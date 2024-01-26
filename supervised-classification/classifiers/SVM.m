classdef SVM < StatsToolboxClassifier
% SVM Wrapper for SVM classifiers from the Stats/ML Toolbox
%
% SVM Methods:
%   SVM - Constructor
%
% See the html documetation or the Classifier help text for more info.
%
% See also Classifier, StatsToolboxClassifier, fitcsvm, ClassificationSVM

% SPDX-License-Identifier: BSD-3-Clause

    properties (SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
        UseGPU
    end

    properties (SetAccess = immutable, GetAccess = public)
        Name
    end

    methods (Static)
        function params = getDefaultParameters()
            params.BoxConstraint = 1;
            params.KernelFunction = "linear";
            params.KernelScale = 1;
            params.PolynomialOrder = 2;
            params.Standardize = false ;
            params.Solver = "SMO";
            params.Cost = ones(2) - eye(2);
            params.ScoreTransform = "none";
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
                if obj.UseGPU
                    gpurng(opts.Seed,"Threefry");
                end
            end

            formattedData = SVM.formatData(trainingData);
            labels = SVM.formatLabels(trainingLabels);

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            params = namedargs2cell(obj.Hyperparams);

            % if we are training on a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                % we have to use convertvars to convert each table
                % variable into a gpuArray.
                data = convertvars(formattedData, 1:width(formattedData), ...
                    @(x) gpuArray(x));
            else
                data = formattedData;
            end

            obj.Model = compact(fitcsvm(data, labels, params{:}));
            
        end

        function obj = SVM(params,opts)
        % SVM Construct an SVM classifier
        %
        %   Name-Value Arguments:
        %       BoxConstraint       - Positive scalar representing the box
        %                             constraint.
        %       KernelFunction      - Which kernel function to use. Options are
        %                             linear, gaussian, rbf, and polynomial.
        %       KernelScale         - Scale factor used to divide predictor
        %                             values.
        %       PolynomialOrder     - If the kernel function is polynomial,
        %                             what order polynomial to use.
        %       Standardize         - Whether to standardize the input data.
        %       Solver              - Which solver to use. Options are ISDA,
        %                             L1QP, and SMO.
        %       FalseNegativeCost   - False negative cost. This parameter
        %                             overrides the Cost parameter.
        %       Cost                - Cost matrix.
        %       ScoreTransform      - Which score transform to use.
        %       UseGPU              - Whether or not to use a GPU for training
        %                             and inference.
        %
        %   To see the default parameter values, run SVM.getDefaultParameters()
        %
        %   For more details on the parameters, see the fitcsvm documentation.
        %
        %   See also fitcsvm
            arguments
                params.BoxConstraint = 1
                params.KernelFunction (1,1) string {mustBeMember(params.KernelFunction,["linear","gaussian","rbf","polynomial"])} = "linear"
                params.KernelScale = 1
                params.PolynomialOrder = 2
                params.Standardize = false 
                params.Solver {mustBeMember(params.Solver,["ISDA","L1QP","SMO"])} = "SMO"
                params.FalseNegativeCost = []
                params.Cost = ones(2) - eye(2)
                params.ScoreTransform = "none"
                opts.UseGPU = false
            end

            % if the kernel isn't polynomial, we can't have the
            % the PolynomialOrder parameter
            if ~strcmpi(params.KernelFunction,"polynomial")
                params = rmfield(params,"PolynomialOrder");
            end

            params = obj.createCostMatrix(params);

            obj.Hyperparams = params;
            obj.UseGPU = opts.UseGPU;

            % Capitalize the kernel function so the classifier name
            % is TitleCase, following the ClassName naming convention.
            kernelFunction = params.KernelFunction;
            kernelFunction{1}(1) = upper(kernelFunction{1}(1));

            if ~strcmpi(params.KernelFunction,"polynomial")
                obj.Name = kernelFunction + "SVM";
            else
                obj.Name = kernelFunction + params.PolynomialOrder + "SVM";
            end
        end


    end
    
end