classdef (Abstract) StatsToolboxClassifier < Classifier

    methods (Static)
        function formattedData = formatData(data)
            formattedData = vertcat(data{:});
        end

        function formattedLabels = formatLabels(labels)
            formattedLabels = vertcat(labels{:});
        end
    end

    methods
        function [labels,scores] = predict(obj,data)

            formattedData = StatsToolboxClassifier.formatData(data);

            % TODO: this gpuArray conversion code only supports tables
            % at the moment. In practice, our features have always been
            % in tables so far, but I could make this more generic so
            % it works for matrices as well.

            % if we are predicting on a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                % we have to use convertvars to convert each table
                % variable into a gpuArray.
                data = convertvars(formattedData, 1:width(formattedData), ...
                    @(x) gpuArray(x));
            else
                data = formattedData;
            end

            [labels,scores] = predict(obj.Model,data);

            if obj.UseGPU && canUseGPU()
                labels = gather(labels);
                scores = gather(scores);
            end
        end
    end

    methods (Static,Access=protected)
        function params = createCostMatrix(params)
            % The "fitc" functions expect a cost matrix, but our constructors take only the
            % false negative cost because we can't have the full cost matrix be an
            % optimizableVariable for bayesopt. Create the cost matrix and remove the false
            % negative cost field so the "fitc" functions are happy.
            if ~isempty(params.FalseNegativeCost)
                params.Cost = [0 1; params.FalseNegativeCost 0];
            end
            
            params = rmfield(params, "FalseNegativeCost");
        end
    end

end
