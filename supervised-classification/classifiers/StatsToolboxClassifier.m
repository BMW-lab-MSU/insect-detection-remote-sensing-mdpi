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
                data = convertvars(formattedData, 1:width(trainingData), ...
                    @(x) gpuArray(x));
            else
                data = formattedData;
            end

            [labels,scores] = predict(obj.Model,data);
        end
    end

end
