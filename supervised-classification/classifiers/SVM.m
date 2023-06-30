classdef SVM < Classifier

    properties (SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
    end

    methods
        function fit(obj,trainingData,labels)

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            params = namedargs2cell(obj.Hyperparams);

            obj.Model = compact(fitcsvm(trainingData, labels, params{:}));
            
        end

        function obj = SVM(params)
            arguments
                % TODO: additional argument validation
                % set default hyperparameters; these default values
                % are the same as MATLAB's default values as of 2023a.
                % This doesn't include all possible parameters; just the ones
                % that are commonly used and/or optimizable in fitcensemble.
                params.BoxConstraint = 1
                params.KernelFunction {mustBeMember(params.KernelFunction,{'linear','gaussian','rbf','polynomial'})} = 'linear'
                params.KernelScale = 1
                params.PolynomialOrder = 2
                params.Standardize = false 
                params.Solver {mustBeMember(params.Solver,{'ISDA','L1QP','SMO'})} = 'SMO'
                params.Cost = ones(2) - eye(2)
                params.ScoreTransform = 'none'
            end

            % if the kernel isn't polynomial, we can't have the
            % the PolynomialOrder parameter
            if ~strcmpi(params.KernelFunction,'polynomial')
                params = rmfield(params,'PolynomialOrder');
            end

            obj.Hyperparams = params;
        end


    end
    
end