classdef (Abstract) TreeEnsemble < StatsToolboxClassifier

% SPDX-License-Identifier: BSD-3-Clause

    properties (SetAccess = protected, GetAccess = public)
        Model
        UseGPU
    end

    properties (Dependent, SetAccess = protected, GetAccess = public)
        Hyperparams
    end

    properties (Abstract, Access = protected)
        TreeParams
        EnsembleParams
        MethodParams
    end

    properties (Abstract, Constant)
        AggregationMethod
    end

    methods
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

            formattedData = TreeEnsemble.formatData(trainingData);
            labels = TreeEnsemble.formatLabels(trainingLabels);

            % convert hyperparameter structs to cell arrays of Name-Value
            % pairs, that way we don't have to type all the Name-Value pairs
            % manually in the function calls
            treeParams = namedargs2cell(obj.TreeParams);
            ensembleParams = namedargs2cell(obj.EnsembleParams);
            methodParams =  namedargs2cell(obj.MethodParams);

            % create reproducible template tree for base learners
            tree = templateTree('Reproducible', true, treeParams{:});

            % if we are training on a GPU, convert the data to a gpuArray
            if obj.UseGPU && canUseGPU()
                % we have to use convertvars to convert each table
                % variable into a gpuArray.
                data = convertvars(formattedData, 1:width(formattedData), ...
                    @(x) gpuArray(x));
            else
                data = formattedData;
            end

            obj.Model = compact(fitcensemble(data, labels, ...
                ensembleParams{:}, methodParams{:}, ...
                Learners=tree, Method=obj.AggregationMethod));
            
        end

        function hyperparams = get.Hyperparams(obj)
            hyperparams = mergeStructs(obj.TreeParams, ...
                obj.EnsembleParams, obj.MethodParams);
        end

    end
    
end