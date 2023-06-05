%% Model fitting function
function model = fitRUSBoost(data, labels, hyperparams)

    if isfield(hyperparams,'CostRatio')
        hyperparams=rmfield(hyperparams,"CostRatio");%not used here,
        %but needed in cvobjfun.m and hyperTuneObjFun.m and its more
        %convenient to just delete it inside this function
    end
    ttHP=struct();  %hyperparameters for template tree
    enHP=struct();  %hyperparameters for fitcensemble function

    ttFields={'MaxNumSplits','MinLeafSize','SplitCriterion'};

    hpNames=fieldnames(hyperparams);
    
    %sorting the hyperparameters into those used for templateTree() and
    %those used for the fitcensemble()
    for i=1:numel(hpNames)
        field=hpNames(i);
        if ismember(field,ttFields)
            ttHP.(char(field))=hyperparams.(char(field));
        else
            enHP.(char(field))=hyperparams.(char(field));
        end
    end

    ttHP=namedargs2cell(ttHP);
    enHP=namedargs2cell(enHP);

    if isempty(ttHP)
        tt=templateTree('Reproducible',true);
    else
        tt=templateTree('Reproducible',true,ttHP{:});
    end

    % convert data to gpuArray
    gpuData = convertvars(data, [1:width(data)], @(x) gpuArray(x));

    if isempty(enHP)
        model=compact(fitcensemble(gpuData,labels,'Method','RUSBoost'));
    else
        model=compact(fitcensemble(gpuData,labels,'Method','RUSBoost',...
            enHP{:}));
    end

%         t = templateTree('Reproducible',true,'MaxNumSplits', ...
%             hyperparams.MaxNumSplits, 'MinLeafSize', ...
%             hyperparams.MinLeafSize,'SplitCriterion', ...
%             hyperparams.SplitCriterion);
%         model = compact(fitcensemble(data, labels, 'Method', ...
%             'RUSBoost', 'Learners', t, 'ScoreTransform', ...
%             hyperparams.ScoreTransform, 'Cost', hyperparams.Cost, ...
%             'ClassNames', hyperparams.ClassNames, 'LearnRate', ...
%             hyperparams.LearnRate, 'NumLearningCycles', ...
%             hyperparams.NumLearningCycles));
        
        
end
