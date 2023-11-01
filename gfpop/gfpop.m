%%% Main wrapper function that takes in all the necessary gfpop info and
%%% reorders the graph and calculates the changepoints.
%%%     For more info on  each of the functions gfpopEdge and gfpopGraph
%%%     use 'help _____' for a description of the inputs and outputs of the
%%%     functions.
%%%
%%%     Inputs:
%%%     data --> vector of doubles containing the data
%%%     graph --> struct containing all of the edges of the graph
%%%     type --> string defining the cost model to use
%%%     weights --> vector of weights (same size as data)
%%%     testMode --> boolean used to debug code. False by default.
%%%
%%%     Ouput:
%%%     result --> struct containing changepoints, states, forced,
%%%                parameters, and the global cost.
%%%
%%%     Example:   
%%%     ouput = gfpop(inputData,updown,"mean",ones(1,length(inputData)));                          
%%%

function result = gfpop(data,graph,type,varargin)

    % Checking inputs
    p = inputParser;
    validTypes = ["mean","variance","exp","poisson","negbin"];
    checkType = @(x) any(matches(validTypes,x));

    addRequired(p,'data',@isvector);
    addRequired(p,'graph',@isstruct);
    addRequired(p,'type',checkType);
    addParameter(p,'weights',ones(1,length(data)),@isvector);
    addParameter(p,'testMode',0,@islogical);
    parse(p,data,graph,type,varargin{:});
    
    % Reordering Graph
    [orderedGraph,vertexNames] = gfpopGraphReorder(p.Results.graph);

    % Running gfpop mex function
    result = gfpop_mex(p.Results.data,orderedGraph,p.Results.type,p.Results.weights,p.Results.testMode);

    % Converting states from integers back to string names
    tmp = [];
    for i = 1:length(result.states)
        tmp = [tmp vertexNames(result.states(i)+1)];
    end
    result.states = tmp;

end