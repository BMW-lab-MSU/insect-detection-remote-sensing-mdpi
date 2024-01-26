classdef (Abstract) DeepLearning1dClassifier < DeepLearningClassifier
% DeepLearning1dClassifier Abstract base class for 1D classifiers from the Deep Learning Toolbox
%
%   See also Classifier, DeepLearningClassifier, CNN1d

% SPDX-License-Identifier: BSD-3-Clause

    methods (Static)

        function formattedData = formatData(data)
        % formatData Format the data how the underlying classifier needs it.
        %   The Deep Learning Toolbox requires the data to be formatted as a
        %   cell array, where each cell is a row from an image.

            % Expand the data into one big matrix so we can convert each row into a cell
            matrix = vertcat(data{:});

            % Convert each row into a cell
            formattedData = num2cell(matrix,2);
        end

        function formattedLabels = formatLabels(labels)
        % formatLabels Format the labels how the underlying classifier needs it.

            % The classifier needs the row labels to be one big array, rather
            % than a cell array where each cell contains an image's row labels.
            % Thus we expand the row labels out of their cells
            tmp = vertcat(labels{:});

            % The Deep Learning Toolbox requires categorical labels, not logical
            formattedLabels = categorical(tmp);
        end
    end

end
