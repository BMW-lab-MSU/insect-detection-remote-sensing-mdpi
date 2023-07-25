classdef CNN1d < DeepLearning1dClassifier

    properties (SetAccess=immutable,GetAccess=public)
        Name
    end

    properties (Access=protected)
        Params
        TrainingParams
        TrainingOptions
    end

    methods (Static)
        function params = getDefaultParameters()
            params.FilterSize=16;
            params.NFilters=10;
            params.DropoutProbability=0.2;
            params.SequenceLength=1024;
            params.NClasses=2;
            params.ClassNames=categorical([false,true]);
            params.Cost=[1 1];
            params.MaxEpochs=20;
            params.InitialLearnRate=0.01;
            params.MiniBatchSize=2048;
        end

        function formattedParams = formatOptimizableParams(optimizableParams)
            % bayesopt uses tables instead of structs, but we need to use
            % structs so we can convert Name-Value pairs into a cell array
            % that we can pass to the classifier constructor
            if isa(optimizableParams,"table")
                formattedParams = table2struct(optimizableParams);
            else
                formattedParams = optimizableParams;
            end

            fieldNames = fields(formattedParams);

            nFilterSizeParams = nnz(contains(fieldNames,"FilterSize"));
            nFiltersParams = nnz(contains(fieldNames,"NFilters"));

            optimizingFilterSize = logical(nFilterSizeParams);
            optimizingNFilters = logical(nFiltersParams);

            % If no filter parameters were passed in, there's nothing more to do
            if ~optimizingFilterSize && ~optimizingNFilters
                return
            end

            if ~optimizingFilterSize
                filterSize = CNN1d.getDefaultParameters().FilterSize;
                nFilterSizeParams = 1;
            end

            if ~optimizingNFilters
                nFilters = CNN1d.getDefaultParameters().NFilters;
                nFiltersParams = 1;
            end

            % Determine how many layers the network will have. Either
            % 1. NFilters and FilterSize have the same number of elements,
            % in which case the number of layers is the number of elements.
            % Each element of NFilters and FilterSize specifies the respective
            % paramaters for each layer.
            % 2. NFilters has 1 element, and FilterSize has multiple. The 
            % number of layers is the number of FilterSize arguments. Each
            % layer has the same number of filters.
            % 3. FilterSize has 1 element, and NFilters has multiple. The
            % number of layers is the number of NFilters arguments. Each
            % layer has the same filter size.
            if nFiltersParams == nFilterSizeParams
                nLayers = nFiltersParams;

                % Create FilterSize argument
                if optimizingFilterSize
                    filterSize = zeros(1,nLayers);
                    for layerNum = 1:nLayers
                        filterSize(layerNum) = formattedParams.("FilterSize" + layerNum);

                        % We don't want the old fields anymore since the
                        % constructor doesn't accept them
                        formattedParams = rmfield(formattedParams,"FilterSize" + layerNum);
                    end
                else
                    filterSize = repelem(filterSize,nLayers);
                end

                % Create NFilters argument
                if optimizingNFilters
                    nFilters = zeros(1,nLayers);
                    for layerNum = 1:nLayers
                        nFilters(layerNum) = formattedParams.("NFilters" + layerNum);

                        % We don't want the old fields anymore since the
                        % constructor doesn't accept them
                        formattedParams = rmfield(formattedParams,"NFilters" + layerNum);
                    end
                else
                    nFilters = repelem(nFilters,nLayers);
                end


            elseif nFiltersParams == 1
                nLayers = nFilterSizeParams;

                filterSize = zeros(1,nLayers);

                % Create NFilters argument
                if optimizingNFilters
                    nFiltersFieldName = fieldNames(contains(fieldNames,"NFilters"));

                    nFilters = repelem(formattedParams.(nFiltersFieldName),nLayers);

                    formattedParams = rmfield(formattedParams,nFiltersFieldName);
                else
                    nFilters = repelem(nFilters,nLayers);
                end

                % Create FilterSize argument.
                % FilterSize will always have more than one optimizable variable
                % in this case. If it only had 1, both FilterSize and NFilters
                % would have had 1 and would have been handled in the first if
                % statment.
                for layerNum = 1:nLayers
                    filterSize(layerNum) = formattedParams.("FilterSize" + layerNum);

                    formattedParams = rmfield(formattedParams,"FilterSize" + layerNum);
                end

            elseif nFilterSizeParams == 1
                nLayers = nFiltersParams;

                nFilters = zeros(1,nLayers);

                % Create FilterSize argument
                if optimizingFilterSize
                    filterSizeFieldName = fieldNames(contains(fieldNames,"FilterSize"));

                    filterSize = repelem(formattedParams.(filterSizeFieldName));

                    formattedParams = rmfield(formattedParams,filterSizeFieldName);
                else
                    filterSize = repelem(filterSize,nLayers);
                end

                % Create Nfilters argument.
                % Nfilters will always have more than one optimizable variable
                % in this case. If it only had 1, both FilterSize and NFilters
                % would have had 1 and would have been handled in the first if
                % statment.
                for layerNum = 1:nLayers
                    nFilters(layerNum) = formattedParams.("NFilters" + layerNum);

                    formattedParams = rmfield(formattedParams,"NFilters" + layerNum);
                end

            else
                error("Number of FilterSize and NFilters parameters are "...
                    + "inconsistent and don't define a valid number of "...
                    + "layers. They must be the same size, or one of "...
                    + "them must have only 1 element.");
            end

            formattedParams.FilterSize = filterSize;
            formattedParams.NFilters = nFilters;
        end
    end

    methods

        function obj = CNN1d(params,trainingOpts,opts)
            arguments
                params.FilterSize=20
                params.NFilters=20
                params.DropoutProbability=0.2
                params.SequenceLength=1024
                params.NClasses=2
                params.ClassNames=categorical([false,true])
                params.FalseNegativeCost=[]
                params.Cost=[1 1]
                trainingOpts.MaxEpochs=5
                trainingOpts.InitialLearnRate=0.01
                trainingOpts.MiniBatchSize=2048
                opts.UseGPU=(true && canUseGPU())
            end

            nLayers = numel(params.FilterSize);

            % Validate that NFilters is the same size as FilterSize. The number
            % of layers is defined by the size of these arguments.
            if numel(params.NFilters) ~= nLayers
                error("NFilters and FilterSize must be the same size");
            end

            obj.Name = "CNN1d" + nLayers + "Layer";

            params = obj.createCostMatrix(params);

            if opts.UseGPU
                executionEnvironment = "gpu";
            else
                executionEnvironment = "cpu";
            end

            obj.Params = params;
            obj.TrainingParams = trainingOpts;
            obj.UseGPU = opts.UseGPU;

            obj.TrainingOptions = trainingOptions("adam",...
                MaxEpochs=trainingOpts.MaxEpochs,...
                InitialLearnRate=trainingOpts.InitialLearnRate,...
                SequenceLength=params.SequenceLength,...
                Verbose=false,...
                MiniBatchSize=trainingOpts.MiniBatchSize,...
                Shuffle="every-epoch",...
                Plots="none",...
                ExecutionEnvironment=executionEnvironment);

            % Create the input layer
            layers = [sequenceInputLayer(1,MinLength=params.SequenceLength)];

            % Add the convolution layers.
            for layerNum = 1:nLayers
                layers = [...
                    layers,...
                    convolution1dLayer(params.FilterSize(layerNum),params.NFilters(layerNum)),...
                    batchNormalizationLayer,...
                    reluLayer,...
                    dropoutLayer(params.DropoutProbability),...
                ];
            end

            % Add the final classification layers
            layers = [...
                layers,...
                globalMaxPooling1dLayer,...
                fullyConnectedLayer(params.NClasses),...
                softmaxLayer,...
                classificationLayer(Classes=params.ClassNames,ClassWeights=params.Cost),...
            ];

            obj.Layers = layers;
        end

    end

end
