classdef (Abstract) StatsToolboxClassifier < Classifier
% StatsToolboxClassifier Abstract base class for classifiers from the Stats/ML toolbox.
%
% See also Classifier

% SPDX-License-Identifier: BSD-3-Clause

    methods (Static)
        % The Stats toolbox classifiers expect the input data to be a table or
        % matrix. Rows are obversvations, and columns are features.
        % We vertically concatenate the matrices in each cell of the cell array
        % to get one matrix (if we are using raw data) or table (if we are
        % using features).
        function formattedData = formatData(data)
            formattedData = vertcat(data{:});
        end

        % The labels need to be a one-dimensional vector, so we unpack the cell
        % array of vectors into a single column vector.
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
        % createCostMatrix Format cost matrix for the underlying classifier
        %
        %   costMatrix = createCostMatrix(falseNegativeCost) formats a cost
        %   matrix for the underlying Stats Toolbox classifier using
        %   falseNegativeCost.
        %
        %   The Stats toolbox classifiers expect a full cost matrix, thus this
        %   method construct the cost matrix using as
        %
        %       [0                  1; 
        %        FalseNegativeCost  0]

            % The "fitc" functions expect a cost matrix, but our constructors
            % take only the false negative cost because we can't have the full
            % cost matrix be an optimizableVariable for bayesopt. Create the
            % cost matrix and remove the false negative cost field so the "fitc"
            % functions are happy. If the false negative cost is empty, just
            % keep the cost as is (either the default value or whatever the
            % caller passed in). False negative cost overrides the Cost
            % parameter. 

            % TODO: we should add a warning if both FalseNegativeCost
            % and Cost were passed in, if possible.
            if ~isempty(params.FalseNegativeCost)
                params.Cost = [0 1; params.FalseNegativeCost 0];
            end
            
            params = rmfield(params, "FalseNegativeCost");
        end
    end

end
