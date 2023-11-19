classdef (Abstract) DeepLearningClassifier < Classifier
    
    properties (SetAccess=protected, GetAccess=public)
        Layers
        Model
        Hyperparams
        UseGPU=true
    end

    properties (Abstract,Access=protected)
        Params
        TrainingParams
        TrainingOptions
    end


    methods
        function hyperparams = get.Hyperparams(obj)
            hyperparams = mergeStructs(obj.Params,obj.TrainingParams);
        end

        function [labels,scores] = predict(obj,data)

            formattedData = obj.formatData(data);

            [labels,scores] = classify(obj.Model,formattedData);
        end

        function fit(obj,trainingData,trainingLabels,opts)
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

            formattedData = obj.formatData(trainingData);
            labels = obj.formatLabels(trainingLabels);

            obj.Model = trainNetwork(formattedData,labels,obj.Layers,obj.TrainingOptions);
        end
    end

    methods (Static,Access=protected)
        function params = createCostMatrix(params)
            % TODO: update comment

            % The "fitc" functions expect a cost matrix, but our constructors take only the
            % false negative cost because we can't have the full cost matrix be an
            % optimizableVariable for bayesopt. Create the cost matrix and remove the false
            % negative cost field so the "fitc" functions are happy. If the false negative cost
            % is empty, just keep the cost as is (either the default value or whatever the caller
            % passed in). False negative cost overrides the Cost parameter.
            % TODO: we should add a warning if both FalseNegativeCost and Cost were passed in, if possible.
            if ~isempty(params.FalseNegativeCost)
                cost = [1,params.FalseNegativeCost];
                cost = cost / mean(cost);
                params.Cost = cost;
            end
            
            params = rmfield(params, "FalseNegativeCost");
        end
    end

end
