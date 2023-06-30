classdef TreeEnsemble (Abstract) < Classifier

    properties (SetAccess = private, GetAccess = public)
        Model
    end

    properties (Dependent)
        Hyperparams
    end

    properties (Access = private)
        TemplateTreeParams
        EnsembleParams
    end

    properties (Abstract)
        MethodParams
    end

    properties (Abstract,Constant)
        AggregationMethod
    end

    methods
        function fit(obj,trainingData,labels)

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            treeParams = namedargs2cell(obj.TemplateTreeParams);
            ensembleParams = namedargs2cell(obj.EnsembleParams);
            methodsParams =  namedargs2cell(obj.MethodParams);

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

            obj.model = compact(fitcensemble(data, labels, ...
                Learners=tree, Method=obj.AggregationMethod, ...
                ensembleParams{:}, methodParams{:}));
            
        end

        function [labels,scores] = predict(obj,newData)

            [labels,scores] = predict(obj.Model,newData);

        end

        function hyperparams = get.Hyperparams(obj)
            hyperparams = mergeStructs(obj.TemplateTreeParams, ...
                obj.EnsembleParams, obj.MethodParams);
        end

    end
    
end