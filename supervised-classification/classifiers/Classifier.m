classdef (Abstract) Classifier < handle

    properties (Abstract, SetAccess = protected, GetAccess = public)
        Model
        Hyperparams
        UseGPU = false
    end
    
    methods (Abstract)
        fit(obj,trainingData,labels)
    end

    methods
        function [labels,scores] = predict(obj,newData)

            % TODO: this gpuArray conversion code only supports tables
            % at the moment. In practice, our features have always been
            % in tables so far, but I could make this more generic so
            % it works for matrices as well.

            % if we are predicting on a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                % we have to use convertvars to convert each table
                % variable into a gpuArray.
                data = convertvars(newData, [1:width(trainingData)], ...
                    @(x) gpuArray(x));
            else
                data = newData;
            end
            
            [labels,scores] = predict(obj.Model,data);
        end
    end

    % TODO: we could add a private method here that handles the if obj.UseGPU stuff

end
