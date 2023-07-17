classdef LSTM < DeepLearning1dClassifier

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
            params.LayerSizes=10
            params.DropoutProbability=0.2
            params.SequenceLength=1024
            params.NClasses=2
            params.ClassNames=categorical([false,true])
            params.FalseNegativeCost=1
            params.MaxEpochs=5
            params.GradientThreshold=1
            params.InitialLearnRate=0.01
            params.MiniBatchSize=2048
        end

        function formattedParams = formatOptimizableParams(optimizableParams)
            % bayesopt uses tables instead of structs, but we need to use
            % structs so we can convert Name-Value pairs into a cell array
            % that we can pass to the classifier constructor
            formattedParams = table2struct(optimizableParams);

            fieldNames = fields(formattedParams);

            nLayers = nnz(contains(fieldNames,"LayerSize"));

            if nLayers == 0
                % We aren't optimizing the layer sizes, so there's nothing else
                % to do. The rest of this function would still work, but we
                % might as well return early instead of having LayerSizes
                % be empty.
                return;
            end

            layerSizes = zeros(1,nLayers);

            for layerNum = 1:nLayers
                field = "LayerSize" + layerNum;

                % Add the layer size into the layers array
                layerSizes(layerNum) = formattedParams.(field);

                % Remove LayerSize<layerNum> field from parameters structure
                formattedParams = rmfield(formattedParams,field);
            end

            formattedParams.LayerSizes = layerSizes;
        end
    end

    methods

        function obj = LSTM(params,trainingOpts,opts)
            arguments
                params.LayerSizes=10
                params.DropoutProbability=0.2
                params.SequenceLength=1024
                params.NClasses=2
                params.ClassNames=categorical([false,true])
                params.FalseNegativeCost=1
                trainingOpts.MaxEpochs=5
                trainingOpts.GradientThreshold=1
                trainingOpts.InitialLearnRate=0.01
                trainingOpts.MiniBatchSize=2048
                opts.UseGPU=(true && canUseGPU())
            end

            nLayers = numel(params.LayerSizes);

            obj.Name = "LSTM" + nLayers + "Layer";

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
                GradientThreshold=trainingOpts.GradientThreshold,...
                Shuffle="every-epoch",...
                Plots="none",...
                ExecutionEnvironment=executionEnvironment);

            % Create the input layer
            layers = [sequenceInputLayer(1,MinLength=params.SequenceLength)];

            % Add the lstm layers.
            for layerNum = 1:nLayers
                layers = [...
                    layers,...
                    bilstmLayer(params.LayerSizes(layerNum),OutputMode="last"),...
                    layerNormalizationLayer,...
                    dropoutLayer(params.DropoutProbability),...
                ];
            end

            % Add the final classification layers
            layers = [...
                layers,...
                fullyConnectedLayer(params.NClasses),...
                softmaxLayer,...
                classificationLayer(Classes=params.ClassNames,ClassWeights=params.Cost),...
            ];

            obj.Layers = layers;
        end

    end

end
