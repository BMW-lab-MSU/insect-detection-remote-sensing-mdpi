classdef (Abstract) DeepLearning2dClassifier < DeepLearningClassifier
% DeepLearning2dClassifier Abstract base class for 2D classifiers from the Deep Learning Toolbox
%
%   See also Classifier, DeepLearningClassifier, CNN2d

% SPDX-License-Identifier: BSD-3-Clause

    methods (Static)

        function formattedData = formatData(data)
        % formatData Format the data how the underlying classifier needs it.
        % 
        %   Image CNNs expect the data input to be 4-D array of 2D images:
        %   width x height x (num channels) x (num images)
            
            % Num channels is always one, so we just need to concatenate along
            % each image along the 4th dimension. The 3rd dimension (num
            % channels) will be a singleton. data{:} returns a comma-separated
            % list, which we can then concatenate.
            formattedData = cat(4,data{:});
        end

        function formattedLabels = formatLabels(labels)
        % formatLabels Format the labels how the underlying classifier needs it.
        %
        %   The Deep Learning Toolbox requires categorical labels, not
        %   logical. The 2D classifiers operate on the image labels, which are
        %   already a 1D logical array.
            formattedLabels = categorical(labels);
        end
    end

end
