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
            params.FilterSize=10;
            params.NFilters=10;
            params.DropoutProbability=0.2;
            params.SequenceLength=1024;
            params.NClasses=2;
            params.ClassNames=categorical([false,true]);
            params.FalseNegativeCost=1;
            params.MaxEpochs=5;
            params.InitialLearnRate=0.01;
            params.MiniBatchSize=2048;
        end

        function formattedParams = formatOptimizableParams(optimizableParams)
            % bayesopt using tables instead of structs, but we need to use
            % structs so we can convert Name-Value pairs into a cell array
            % that we can pass to the classifier constructor
            formattedParams = table2struct(optimizableParams);

            fieldNames = fields(formattedParams);

            nFilterSizeParams = nnz(contains(fieldNames,"FilterSize"))
            nFiltersParams = nnz(contains(fieldNames,"NFilters"));

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

                filterSize = zeros(1,nLayers);
                nFilters = zeros(1,nLayers);

                % Create the FilterSize and NFilter arrays
                for layerNum = 1:nLayers
                    filterSize(layerNum) = formattedParams.("FilterSize" + layerNum);
                    nFilters(layerNum) = formattedParams.("NFilters" + layerNum);

                    % Remove individual FilterSize and NFilters field since
                    % they are combined into arrays
                    formattedParams = rmfield(formattedParams,"FilterSize" + layerNum);
                    formattedParams = rmfield(formattedParams,"NFilters" + layerNum);
                end

            elseif nFiltersParams == 1
                nLayers = nFilterSizeParams;

                filterSize = zeros(1,nLayers);
                nFilters = zeros(1,1);

                nFiltersFieldName = fieldNames(find(contains(fieldNames,"NFilters")));

                % Create the FilterSize and NFilter arrays
                for layerNum = 1:nLayers
                    filterSize(layerNum) = formattedParams.("FilterSize" + layerNum);
                    nFilters(layerNum) = formattedParams.(nFiltersFieldName);

                    % Remove individual FilterSize fields
                    formattedParams = rmfield(formattedParams,"FilterSize" + layerNum);
                end

                formattedParams = rmfield(formattedParams,nFiltersFieldName);

            elseif nFilterSizeParams == 1
                nLayers = nFiltersParams;

                filterSize = zeros(1,1);
                nFilters = zeros(1,nLayers);

                filterSizeFieldName = fieldNames(find(contains(fieldNames,"FilterSize")));

                % Create the FilterSize and NFilter arrays
                for layerNum = 1:nLayers
                    nFilters(layerNum) = formattedParams.("NFilters" + layerNum);
                    filterSize(layerNum) = formattedParams.(filterSizeFieldName);

                    % Remove individual NFilters fields
                    formattedParams = rmfield(formattedParams,"NFilters" + layerNum);
                end

                formattedParams = rmfield(formattedParams,filterSizeFieldName);

            else
                error("Number of FilterSize and NFilters parameters are ",...
                    + "inconsistent and don't define a valid number of ",...
                    + "layers. They must be the same size, or one of ",...
                    + "them must have only 1 element.");
            end

            formattedParams.LayerSizes = layerSizes;
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
                params.FalseNegativeCost=1
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

            obj.Name = "CNN1d" + nLayers + "Layers";

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
