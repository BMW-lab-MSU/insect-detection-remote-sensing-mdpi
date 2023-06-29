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
            treeParamsCell = namedargs2cell(obj.TemplateTreeParams);
            ensembleParamsCell = namedargs2cell(obj.EnsembleParams)

            % create template tree for base learners
            tree = templateTree('Reproducible', true, treeParamsCell{:});

            % if we are training on a GPU, convert the data to a gpuArray
            if obj.UseGPU
                % we have to use convertvars to convert each table
                % variable into a gpuArray.
                data = convertvars(trainingData, [1:width(trainingData)], ...
                    @(x) gpuArray(x));
            else
                data = trainingData;
            end

            obj.model = compact(fitcensemble(data, labels, ...
                Learners=tree, Method=obj.AggregationMethod, ...
                ensembleParamsCell{:}));
            
        end

        function [labels,scores] = predict(obj,newData)

            [labels,scores] = predict(obj.Model,newData);

        end

        function hyperparams = get.Hyperparams(obj)
            tmp = mergeStructs(obj.TemplateTreeParams, ...
                obj.EnsembleParams)
            hyperparams = mergeStructs
        end

    end
    
end