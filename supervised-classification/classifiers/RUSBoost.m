classdef RUSBoost < TreeEnsemble
% RUSBoost Wrapper for RUSBoost classifiers
%
%   RUSBoost Methods:
%       RUSBoost - Constructor
%
%   See the html documentation or the Classifier help text for information on
%   the other methods.
%
%   See also Classifier, TreeEnsemble

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
        % RUSBoost Constructor an RUSBoost classifier
        %
        %   Name-Value Arguments:
        %       MaxNumSplits            - Maximium number of decision splits
        %                                 per tree
        %       MinLeafSize             - Each leaf has at least MinLeafSize
        %                                 observations per tree leaf
        %       NumVariablesToSample    - Number of predictors to select at
        %                                 random for each split
        %       SplitCriterion          - Criterion for choosing a split.
        %                                 Options are gdi, deviance, and twoing
        %       NumLearningCycles       - Number of ensemble learning cycles
        %       FalseNegativeCost       - False negative cost to use in the
        %                                 cost matrix. This parameter overrides
        %                                 the Cost parameter.
        %       Cost                    - Cost matrix
        %       ScoreTransform          - Which score transform to use
        %       LearnRate               - Learning rate for shrinkage 
        %       UseGPU                  - Whether to use a GPU for training
        %                                 and inference.
        %
        %   For default values, run RUSBoost.getDefaultParameters().
        %
        %   See the documentation for fitcensemble and templatetree for more
        %   information on parameter values and meanings.
        %
        %   See also fitcensemble, templatetree
            arguments
                % These default values are the same as MATLAB's default values
                % as of 2023a. This doesn't include  all possible parameters;
                % just the ones that are commonly used and/or optimizable in
                % fitcensemble.
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