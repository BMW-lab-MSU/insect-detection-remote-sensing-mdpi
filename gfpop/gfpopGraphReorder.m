%%% Invisible function that takes in a graph structure and rearranges it
%%% into a specific order for the gfpop function.

function [orderGraph,vertexNames] = gfpopGraphReorder(input)
    
inputGraph = table(input.state1',input.state2',input.type',input.parameter',input.penalty',input.K',input.a',input.min',input.max','VariableNames',["state1" "state2" "type" "parameter" "penalty" "K" "a" "min" "max"]);

% Separate start and end nodes from regular edges
graphNA = inputGraph(isnan(inputGraph.penalty),:);
graphVtemp = inputGraph(~isnan(inputGraph.penalty),:);
myVertices = unique([graphVtemp.state1 graphVtemp.state2],'stable');

% Transform abs edge into up and down edges 
absEdge = graphVtemp(graphVtemp.type == "abs",:);
if(~isempty(absEdge.state1))
    graphVtemp(absEdge).type = "down";
    addtoGraphVV = graphVtemp(absEdge,:);
    addtoGraphVV.type = "up";
    graphV = [graphVtemp addtoGraphVV];
else
    graphV = graphVtemp;
end

% Create a new graph
myNewGraph = table('Size',[0 9],'VariableTypes',{'string' 'string' 'string' 'double' 'double' 'double' 'double' 'double' 'double'},'VariableNames',["state1" "state2" "type" "parameter" "penalty" "K" "a" "min" "max"]);
selectNull = graphV.type == "null";
graphV.penalty(selectNull,:) = -1;

for(i = 1:length(myVertices))
    vertex = myVertices(i);
    selectRaw = graphV(graphV.state2 == vertex,:);
    ordre = sortrows(selectRaw,"penalty");
    selectRaw = ordre;
    myNewGraph = [myNewGraph; selectRaw];
end

myNewGraph = [myNewGraph; graphNA];
selectNull = myNewGraph.type == "null";
myNewGraph.penalty(selectNull,:) = 0;

% Label the vertices with integers from 0 to nbVertices
for(i = 1:length(myNewGraph.state1))
    myNewGraph.state1(i) = find(myNewGraph.state1(i) == myVertices) - 1;
    if(~ismissing(myNewGraph.state2(i)))
        myNewGraph.state2(i) = find(myNewGraph.state2(i) == myVertices) - 1;
    else
        myNewGraph.state2(i) = -1;
    end
end

myNewGraph.state1 = double(myNewGraph.state1);
myNewGraph.state2 = double(myNewGraph.state2);

orderGraph = struct("state1",myNewGraph.state1',"state2",myNewGraph.state2',"type",myNewGraph.type',"parameter",myNewGraph.parameter', ...
    "penalty",myNewGraph.penalty',"K",myNewGraph.K',"a",myNewGraph.a',"min",myNewGraph.min',"max",myNewGraph.max');
vertexNames = myVertices;

end