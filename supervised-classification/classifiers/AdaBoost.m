classdef AdaBoost < TreeEnsemble

    properties (Access = private)
        TemplateTreeParams
        EnsembleParams
    end

    properties(Constant)
        AggregationMethod = "AdaBoostM1"
    end

    methods

    end
    
end