classdef (Abstract) DeepLearningClassifier < Classifier

    methods
        function [labels,scores] = predict(obj,data)

            formattedData = obj.formatData(data);

            % if we are using a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                data = gpuArray(formattedData);
            else
                data = formattedData;
            end

            [labels,scores] = classify(obj.Model,data);

            if obj.UseGPU && canUseGPU()
                labels = gather(labels);
                scores = gather(scores);
            end

            % Convert labels from categorical to logical
            labels = labels == "true";
        end

        function fit(obj,trainingData,trainingLabels)

            formattedData = obj.formatData(trainingData);
            labels = obj.formatLabels(trainingLabels);

            % if we are training on a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                data = gpuArray(formattedData);
            else
                data = formattedData;
            end

            obj.Model = trainNetwork(data,labels,obj.Layers,obj.TrainingOptions);
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
