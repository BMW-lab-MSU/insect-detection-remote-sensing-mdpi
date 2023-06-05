%% Model fitting function
function model = fitNet(data, labels, hyperparams)

    Weights=ones(length(labels),1);
    Weights(labels)=hyperparams.CostRatio;
    hyperparams.Weights=Weights;

    hyperparams=rmfield(hyperparams,"CostRatio");%not used here,
        %but needed in cvobjfun.m and hyperTuneObjFun.m and its more
        %convenient to just delete it inside this function
    hyperparams=namedargs2cell(hyperparams);
    model = compact(fitcnet(data, labels,hyperparams{:}));
end