classdef RUSBoost < TreeEnsemble

% SPDX-License-Identifier: BSD-3-Clause

    properties (Access = protected)
        TreeParams
        EnsembleParams
        MethodParams
    end

    properties (Constant)
        AggregationMethod = "RUSBoost"
    end

    properties (SetAccess = immutable, GetAccess = public)
        Name = "RUSBoost"
    end

    methods (Static)
        function params = getDefaultParameters()
            params.MaxNumSplits = 10;
            params.MinLeafSize = 1;
            params.NumVariablesToSample = "all";
            params.SplitCriterion = "gdi";
            params.NumLearningCycles = 100;
            params.Cost = ones(2) - eye(2);
            params.ScoreTransform = "none";
            params.LearnRate = 1;
        end
    end

    methods
        function obj = RUSBoost(treeParams,ensembleParams,params,opts)
            arguments
                % TODO: additional argument validation
                % set default hyperparameters; these default values
                % are the same as MATLAB's default values as of 2023a.
                % This doesn't include  all possible parameters; just the ones
                % that are commonly used and/or optimizable in fitcensemble.
                treeParams.MaxNumSplits = 10
                treeParams.MinLeafSize = 1
                treeParams.NumVariablesToSample = "all"
                treeParams.SplitCriterion {mustBeMember(treeParams.SplitCriterion,["gdi","deviance","twoing"])} = "gdi"
                ensembleParams.NumLearningCycles = 100
                ensembleParams.FalseNegativeCost = []
                ensembleParams.Cost = ones(2) - eye(2)
                ensembleParams.ScoreTransform = "none"
                params.LearnRate = 1
                opts.UseGPU = false;
            end

            ensembleParams = obj.createCostMatrix(ensembleParams);

            obj.TreeParams = treeParams;
            obj.EnsembleParams = ensembleParams;
            obj.MethodParams = params;
            obj.UseGPU = opts.UseGPU;
        end
        
    end
    
end