classdef AdaBoost < TreeEnsemble

    properties (Access = protected)
        TreeParams
        EnsembleParams
        MethodParams
    end

    properties(Constant)
        AggregationMethod = "AdaBoostM1"
    end

    methods
        function obj = AdaBoost(treeParams,ensembleParams,params,opts)
            arguments
                % TODO: additional argument validation
                % set default hyperparameters; these default values
                % are the same as MATLAB's default values as of 2023a.
                % This doesn't include  all possible parameters; just the ones
                % that are commonly used and/or optimizable in fitcensemble.
                treeParams.MaxNumSplits = 10
                treeParams.MinLeafSize = 1
                treeParams.NumVariablesToSample = 'all'
                treeParams.SplitCriterion {mustBeMember(treeParams.SplitCriterion,{'gdi','deviance','twoing'})} = 'gdi'
                ensembleParams.NumLearningCycles = 100
                ensembleParams.Cost = ones(2) - eye(2)
                ensembleParams.ScoreTransform = 'none'
                params.LearnRate = 1
                opts.UseGPU = false;
            end

            obj.TreeParams = treeParams;
            obj.EnsembleParams = ensembleParams;
            obj.MethodParams = params;
            obj.UseGPU = opts.UseGPU;
        end
        
    end
    
end