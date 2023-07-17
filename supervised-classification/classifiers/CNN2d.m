classdef CNN2d < DeepLearning2dClassifier

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
            params.FilterSize=[3 3];
            params.NFilters=20;
            params.DropoutProbability=0.2;
            params.ImageSize=[178,1024];;
            params.NClasses=2;
            params.ClassNames=categorical([false,true]);
            params.FalseNegativeCost=1;
            params.MaxEpochs=20;
            params.InitialLearnRate=0.01;
            params.MiniBatchSize=64;
        end

        function formattedParams = formatOptimizableParams(optimizableParams)
            % bayesopt uses tables instead of structs, but we need to use
            % structs so we can convert Name-Value pairs into a cell array
            % that we can pass to the classifier constructor
            formattedParams = table2struct(optimizableParams);

            fieldNames = fields(formattedParams);

            % The filter size can be specified as a single number if the filter
            % is square, or it can be rectangular with different height/width.
            % Consequently, the optimizableVariables can specified as either
            % "FilterSizeX" for square filters, or "FilterHeightX" and
            % "FilterWidthX" for rectangular filters.
            nFilterSizeParams = nnz(contains(fieldNames,"FilterSize"));
            nFilterHeightParams = nnz(contains(fieldNames,"FilterHeight"));
            nFilterWidthParams = nnz(contains(fieldNames,"FilterWidth"));
            nFiltersParams = nnz(contains(fieldNames,"NFilters"));



            if nFilterSizeParams > 0
                filterIsSquare = true;
                optimizingFilterSize = true;
            elseif nFilterHeightParams > 0 || nFilterWidthParams > 0
                filterIsSquare = false;
                optimizingFilterSize = true;
            else
                optimizingFilterSize = false;
            end

            optimizingNFilters = logical(nFiltersParams);

            % If no filter parameters were passed in, there's nothing more to do
            if ~optimizingFilterSize && ~optimizingNFilters
                return
            end

            if optimizingFilterSize
                % FilterSize must be specified by itself without FilterHeight/Width.
                if nFilterSizeParams > 0 && (nFilterHeightParams > 0 || nFilterWidthParams > 0)
                    error("FilterSize cannot be specified along with FilterHeight or FilterWidth");
                end
            end

            if optimizingFilterSize
                if ~filterIsSquare
                    if nFilterWidthParams == 0 
                        error("There must be at least one FilterWidth variable"...
                            + " since at least one FilterHeight variable was specified");
                    elseif nFilterHeightParams == 0
                        error("There must be at least one FilterWidth variable"...
                            + " since at least one FilterHeight variable was specified");
                    end
                end
            end


            if optimizingFilterSize
                % Assmeble the FilterSize argument by combining the FilterSize variables
                % or the FilterHeight and FilterWidth variables. 
                if filterIsSquare
                    if nFilterSizeParams > 1
                        filterSize = zeros(nFilterSizeParams,1);
                        for layerNum = 1:nFilterSizeParams
                            filterSize(layerNum) = formattedParams.("FilterSize" + layerNum);

                            % We don't want the old fields anymore since the
                            % constructor doesn't accept them
                            formattedParams = rmfield(formattedParams,"FilterSize" + layerNum);
                        end
                    else
                        filterSizeFieldName = fieldNames(find(contains(fieldNames,"FilterSize")));
                        filterSize = formattedParams.(filterSizeFieldName);

                        formattedParams = rmfield(formattedParams,filterSizeFieldName);
                    end

                else
                    % Validate that the number of height and width parameters is correct.
                    % 1. We can have the same number of FilterHeightX and
                    % FilterWidthX parameters, each one specifying the height and width
                    % for layer X.
                    % 2. There can be one FilterHeight/FilterWidth parameter, and the
                    % other parameter can have multiple. In this case, whichever
                    % parameter was only specified once, is the same for each layer.
                    % If the number of height and width parameters are valid, then
                    % assmeble the FilterSize argument.
                    if nFilterHeightParams == nFilterWidthParams
                        filterSize = zeros(nFilterHeightParams,2);

                        for layerNum = 1:numel(filterSize)
                            filterHeight = formattedParams.("FilterHeight" + layerNum);
                            filterWidth = formattedParams.("FilterWidth" + layerNum);
                            filterSize(layerNum,:) = [filterHeight,filterWidth];

                            % We don't want the old fields anymore since the
                            % constructor doesn't accept them
                            formattedParams = rmfield(formattedParams,"FilterHeight" + layerNum);
                            formattedParams = rmfield(formattedParams,"FilterWidth" + layerNum);
                        end
                    elseif nFilterWidthParams == 1 && nFilterHeightParams > 1
                        filterSize = zeros(nFilterHeightParams,2);

                        filterWidthFieldName = fieldNames(find(contains(fieldNames,"FilterWidth")));

                        for layerNum = 1:numel(filterSize)
                            filterHeight = formattedParams.("FilterHeight" + layerNum);
                            filterWidth = formattedParams.(filterWidthFieldName);
                            filterSize(layerNum,:) = [filterHeight,filterWidth];

                            % We don't want the old fields anymore since the
                            % constructor doesn't accept them
                            formattedParams = rmfield(formattedParams,"FilterHeight" + layerNum);
                            formattedParams = rmfield(formattedParams,filterWidthFieldName);
                        end
                    elseif nFilterHeightParams == 1 && nFilterWidthParams > 1
                        filterSize = zeros(nFilterWidthParams,2);

                        filterHeightFieldName = fieldNames(find(contains(fieldNames,"FilterHeight")));

                        for layerNum = 1:numel(filterSize)
                            filterHeight = formattedParams.(filterHeightFieldName);
                            filterWidth = formattedParams.("FilterWidth" + layerNum);
                            filterSize(layerNum,:) = [filterHeight,filterWidth];

                            % We don't want the old fields anymore since the
                            % constructor doesn't accept them
                            formattedParams = rmfield(formattedParams,filterHeightFieldName);
                            formattedParams = rmfield(formattedParams,"FilterWidth" + layerNum);
                        end
                    else
                        error("Incorrect number of FilterHeight and FilterWidth variables."...
                            + " The number of variables must either be the same"...
                            + ", the number of FilterHeight variables == 1 and"...
                            + " the number of FilterWidth variables > 1, or vice versa.");
                    end
                end
            else
                filterSize = CNN2d.getDefaultParameters().FilterSize;
            end

                    
            if optimizingNFilters
                % Assmble the NFilters argument and validate that the NFilters
                % and FilterSize argument sizes are consistent, i.e. they specify
                % a valid number of layers.
                % The number of layers is determined by the following. Either
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
                if nFiltersParams == height(filterSize)
                    nLayers = nFiltersParams;

                    nFilters = zeros(1,nLayers);

                    for layerNum = 1:nLayers
                        nFilters(layerNum) = formattedParams.("NFilters" + layerNum);

                        % We don't want the old fields anymore since the
                        % constructor doesn't accept them
                        formattedParams = rmfield(formattedParams,"NFilters" + layerNum);
                    end

                elseif nFiltersParams == 1
                    nLayers = height(filterSize);

                    nFilters = zeros(1,nLayers);

                    nFiltersFieldName = fieldNames(contains(fieldNames,"NFilters"));

                    for layerNum = 1:nLayers
                        nFilters(layerNum) = formattedParams.(nFiltersFieldName);
                    end

                    formattedParams = rmfield(formattedParams,nFiltersFieldName);

                elseif nFilterSizeParams == 1
                    % We need to replicate the FilterSize argument for each
                    % nFilters argument since 
                    nLayers = nFiltersParams;

                    filterSizeOld = filterSize;

                    nFilters = zeros(1,nLayers);
                    filterSize = zeros(nLayers,width(filterSizeOld));

                    for layerNum = 1:nLayers
                        nFilters(layerNum) = formattedParams.("NFilters" + layerNum);
                        filterSize(layerNum,:) = filterSizeOld;

                        % Remove individual NFilters fields
                        formattedParams = rmfield(formattedParams,"NFilters" + layerNum);
                    end

                else
                    error("Number of FilterSize and NFilters parameters are "...
                        + "inconsistent and don't define a valid number of "...
                        + "layers. They must be the same size, or one of "...
                        + "them must have only 1 element.");
                end
            else
                nLayers = height(filterSize);
                nFilters = repelem(CNN2d.getDefaultParameters().NFilters,nLayers);
            end

            formattedParams.FilterSize = filterSize;
            formattedParams.NFilters = nFilters;
        end
    end

    methods

        function obj = CNN2d(params,trainingOpts,opts)
            arguments
                params.FilterSize=[3 3]
                params.NFilters=20
                params.DropoutProbability=0.2
                params.ImageSize=[178,1024];
                params.NClasses=2
                params.ClassNames=categorical([false,true])
                params.FalseNegativeCost=1
                trainingOpts.MaxEpochs=20
                trainingOpts.InitialLearnRate=0.01
                trainingOpts.MiniBatchSize=64
                opts.UseGPU=(true && canUseGPU())
            end

            nLayers = height(params.FilterSize);

            % Validate that NFilters is the same size as FilterSize. The number
            % of layers is defined by the size of these arguments.
            if numel(params.NFilters) ~= nLayers
                error("NFilters and FilterSize must be the same size");
            end

            obj.Name = "CNN2d" + nLayers + "Layer";

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
                Verbose=false,...
                MiniBatchSize=trainingOpts.MiniBatchSize,...
                Shuffle="every-epoch",...
                Plots="none",...
                ExecutionEnvironment=executionEnvironment);

            % Create the input layer
            layers = [imageInputLayer([params.ImageSize,1])];

            % Add the convolution layers.
            for layerNum = 1:nLayers
                layers = [...
                    layers,...
                    convolution2dLayer(params.FilterSize(layerNum,:),...
                        params.NFilters(layerNum),Padding="same"),...
                    batchNormalizationLayer,...
                    reluLayer,...
                    maxPooling2dLayer(params.FilterSize(layerNum,:),...
                        Stride=2,Padding="same"),...
                    dropoutLayer(params.DropoutProbability),...
                ];
            end

            % Add the final classification layers
            layers = [...
                layers,...
                globalMaxPooling2dLayer,...
                fullyConnectedLayer(params.NClasses),...
                softmaxLayer,...
                classificationLayer(Classes=params.ClassNames,ClassWeights=params.Cost),...
            ];

            obj.Layers = layers;
        end

    end

end
