classdef (Abstract) DeepLearning2dClassifier < DeepLearningClassifier

    methods (Static)

        function formattedData = formatData(data)
            % Image CNNs expect the data input to be 4-D array of 2D images:
            % width x height x (num channels) x (num images)
            
            % Num channels is always one, so we just need to concatenate along each image
            % along the 4th dimension. The 3rd dimension (num channels) will be a singleton.
            % data{:} returns a comma-separated list, which we can then concatenate.
            formattedData = cat(4,data{:});
        end

        function formattedLabels = formatLabels(labels)

            % The Deep Learning Toolbox requires categorical labels, not logical.
            % The 2D classifiers operate on the image labels, which are already
            % a 1D logical array.
            formattedLabels = categorical(labels);
        end
    end

end
