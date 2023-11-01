%%% Takes in multiple edges from gfpopEdge.m and combines them into a
%%% single structure to be implemented into gfpop.m.
%%%
%%%     INPUTS:
%%%     [Required]
%%%     edges --> vector of edges constructed from gfpopEdge.m
%%%
%%%     [Optional]
%%%     User-Specified Graphs:
%%%     startState --> string of the starting state for gfpop.m
%%%     endState --> string of the ending state for gfpop.m
%%%     allNullEdges --> boolean for creating a null edge for each state
%%%
%%%     Preset Graphs:
%%%     decay --> nonnegative to give strength to decay into edge
%%%     gap --> nonnegative to constrain size of gap in state change
%%%     penalty --> nonnegative double of the penalty for the edge.
%%%     K --> positive double of the robust biweight gaussian loss
%%%     a --> positive double of the slope for the huber robust loss
%%%
%%%     OUTPUTS:
%%%     outputGraph --> Output structure containing graph of all edges
%%%
%%%     EXAMPLE:
%%%     exGraph = gfpopGraph([upEdge dwEdge],startState="up",endState="down",allNullEdges=true);
%%%     

function outputGraph = gfpopGraph(varargin)

    % Setting up optional inputs
    p = inputParser;
    nonNeg = @(x) assert(isnumeric(x) && (x>=0),"Value must be nonnegative");

    % Checking inputs for required and optional values
    % User Defined Graph
    addParameter(p,'edgesIn',[],@isstruct);
    addParameter(p,'startState',[],@isstring);
    addParameter(p,'endState',[],@isstring);
    addParameter(p,'allNullEdges',false,@islogical);
    % Preset Graph
    validPresets = {'empty','std','isotonic','updown','relevant'};
    checkPresets = @(x) any(validatestring(x,validPresets));
    addParameter(p,'preset',[],checkPresets);
    addParameter(p,'decay',1,nonNeg);
    addParameter(p,'gap',0,nonNeg);
    addParameter(p,'penalty',0,nonNeg);
    addParameter(p,'K',Inf,nonNeg);
    addParameter(p,'a',0,nonNeg);

    % Parsing inputs together
    parse(p,varargin{:});
    edges = p.Results.edgesIn;
    startState = p.Results.startState;
    endState = p.Results.endState;
    allNullEdges = p.Results.allNullEdges;
    preset = p.Results.preset;
    decay = p.Results.decay;
    gap = p.Results.gap;
    penalty = p.Results.penalty;
    K = p.Results.K;
    a = p.Results.a;

    % Constructing user graph is preset graph input
    if(isempty(preset))
        % Declaring vectors
        state1vec = [];
        state2vec = [];
        typevec = [];
        paramvec = [];
        penaltyvec = [];
        kvec = [];
        avec = [];
        minvec = [];
        maxvec = [];
    
        % Defined edges
        for i = 1:length(edges)
            tempEdge = edges(i);
            state1vec = [state1vec tempEdge.state1];
            state2vec = [state2vec tempEdge.state2];
            typevec = [typevec tempEdge.type];
            paramvec = [paramvec tempEdge.parameter];
            penaltyvec = [penaltyvec tempEdge.penalty];
            kvec = [kvec tempEdge.k];
            avec = [avec tempEdge.a];
            minvec = [minvec tempEdge.min];
            maxvec = [maxvec tempEdge.max];
        end
    
        % Adding optional inputs
        if(allNullEdges)
            uniqueVectors = unique([state1vec state2vec]);
            for i = 1:length(uniqueVectors)
                state1vec = [state1vec uniqueVectors(i)];
                state2vec = [state2vec uniqueVectors(i)];
                typevec = [typevec "null"];
                paramvec = [paramvec decay];
                penaltyvec = [penaltyvec 0];
                kvec = [kvec Inf];
                avec = [avec 0];
                minvec = [minvec NaN];
                maxvec = [maxvec NaN];
            end
        end
    
        if(~isempty(startState))
            state1vec = [state1vec startState];
            state2vec = [state2vec NaN];
            typevec = [typevec "start"];
            paramvec = [paramvec NaN];
            penaltyvec = [penaltyvec NaN];
            kvec = [kvec NaN];
            avec = [avec NaN];
            minvec = [minvec NaN];
            maxvec = [maxvec NaN];
        end
    
        if(~isempty(endState))
            state1vec = [state1vec endState];
            state2vec = [state2vec NaN];
            typevec = [typevec "end"];
            paramvec = [paramvec NaN];
            penaltyvec = [penaltyvec NaN];
            kvec = [kvec NaN];
            avec = [avec NaN];
            minvec = [minvec NaN];
            maxvec = [maxvec NaN];
        end

    else
        % Creating preset graph if specified
        if(preset == "std")
            state1vec = ["Std" "Std"];
            state2vec = ["Std" "Std"];
            typevec = ["null" "std"];
            paramvec = [decay 0];
            penaltyvec = [0 penalty];
            kvec = [K K];
            avec = [a a];
            minvec = [NaN NaN];
            maxvec = [NaN NaN];
        elseif(preset == "isotonic")
            state1vec = ["Iso" "Iso"];
            state2vec = ["Iso" "Iso"];
            typevec = ["null" "up"];
            paramvec = [decay gap];
            penaltyvec = [0 penalty];
            kvec = [K K];
            avec = [a a];
            minvec = [NaN NaN];
            maxvec = [NaN NaN];
        elseif(preset == "updown")
            state1vec = ["Dw" "Up" "Dw" "Up"];
            state2vec = ["Dw" "Up" "Up" "Dw"];
            typevec = ["null" "null" "up" "down"];
            paramvec = [decay decay gap gap];
            penaltyvec = [0 0 penalty penalty];
            kvec = [K K K K];
            avec = [a a a a];
            minvec = [NaN NaN NaN NaN];
            maxvec = [NaN NaN NaN NaN];
        elseif(preset == "relevant")
            state1vec = ["Abs" "Abs"];
            state2vec = ["Abs" "Abs"];
            typevec = ["null" "abs"];
            paramvec = [decay gap];
            penaltyvec = [0 penalty];
            kvec = [K K];
            avec = [a a];
            minvec = [NaN NaN];
            maxvec = [NaN NaN];
        end

    end

     outputGraph = struct("state1",state1vec,"state2",state2vec,"type",typevec,"parameter",paramvec, ...
                   "penalty", penaltyvec,"K",kvec,"a",avec,"min",minvec,"max",maxvec);

end