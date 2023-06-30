classdef (Abstract) TreeEnsemble < Classifier

    properties (SetAccess = protected, GetAccess = public)
        Model
        UseGPU
    end

    properties (Dependent, SetAccess = protected, GetAccess = public)
        Hyperparams
    end

    properties (Abstract, Access = protected)
        TreeParams
        EnsembleParams
        MethodParams
    end

    properties (Abstract, Constant)
        AggregationMethod
    end

    methods
        function fit(obj,trainingData,labels)

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            treeParams = namedargs2cell(obj.TreeParams);
            ensembleParams = namedargs2cell(obj.EnsembleParams);
            methodParams =  namedargs2cell(obj.MethodParams);

            % create template tree for base learners
            tree = templateTree('Reproducible', true, treeParams{:});

            % if we are training on a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                % we have to use convertvars to convert each table
                % variable into a gpuArray.
                data = convertvars(trainingData, [1:width(trainingData)], ...
                    @(x) gpuArray(x));
            else
                data = trainingData;
            end

            obj.Model = compact(fitcensemble(data, labels, ...
                ensembleParams{:}, methodParams{:}, ...
                Learners=tree, Method=obj.AggregationMethod));
            
        end

        function hyperparams = get.Hyperparams(obj)
            hyperparams = mergeStructs(obj.TreeParams, ...
                obj.EnsembleParams, obj.MethodParams);
        end

    end
    
end