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
            params.NLayers=2;
            params.FilterSize=20;
            params.NFilters=20;
            params.DropoutProbability=0.2;
            params.SequenceLength=1024;
            params.NClasses=2;
            params.ClassNames=categorical([false,true]);
            params.FalseNegativeCost=1;
            params.MaxEpochs=5;
            params.InitialLearnRate=0.01;
            params.MiniBatchSize=2048;
        end
    end

    methods

        function obj = CNN1d(params,trainingOpts,opts)
            arguments
                params.NLayers=2
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
                opts.UseGPU=true
            end

            obj.Name = "CNN1d" + params.NLayers + "Layers";

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

            layers = [sequenceInputLayer(1,MinLength=params.SequenceLength)];

            % Add the convolution layers. Each layer is identical for now.
            for layerNum = 1:params.NLayers
                layers = [...
                    layers,...
                    convolution1dLayer(params.FilterSize,params.NFilters),...
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
