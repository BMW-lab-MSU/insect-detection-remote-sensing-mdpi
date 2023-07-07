classdef SVM < StatsToolboxClassifier

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
        function fit(obj,trainingData,trainingLabels)

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
            arguments
                % TODO: additional argument validation
                % set default hyperparameters; these default values
                % are the same as MATLAB's default values as of 2023a.
                % This doesn't include all possible parameters; just the ones
                % that are commonly used and/or optimizable in fitcensemble.
                params.BoxConstraint = 1
                params.KernelFunction {mustBeMember(params.KernelFunction,["linear","gaussian","rbf","polynomial"])} = "linear"
                params.KernelScale = 1
                params.PolynomialOrder = 2
                params.Standardize = false 
                params.Solver {mustBeMember(params.Solver,["ISDA","L1QP","SMO"])} = "SMO"
                params.Cost = ones(2) - eye(2)
                params.ScoreTransform = "none"
                opts.UseGPU = false;
            end

            % if the kernel isn't polynomial, we can't have the
            % the PolynomialOrder parameter
            if ~strcmpi(params.KernelFunction,"polynomial")
                params = rmfield(params,"PolynomialOrder");
            end

            obj.Hyperparams = params;
            obj.UseGPU = opts.UseGPU;
            obj.Name = params.KernelFunction + "SVM";
        end


    end
    
end