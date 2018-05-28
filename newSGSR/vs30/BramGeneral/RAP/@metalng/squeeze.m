function MLC = squeeze(ML)
%SQUEEZE    remove all empty elements out of metalanguage object

%B. Van de Sande 09-10-2003

%-----------------------------------Implementation details----------------------------------
%   If metalng object is already squeezed or if the object is empty the procedure does not
%   have to be performed. Else the following algorithm is used:
%       1.Take all non empty vertices and use these as the vertices for the new squeezed
%         metalanguage object. Also add a new source and sink.
%       2.The edges of a remaining language element can be obtained be looking for all the
%         vertices (including itself) that are connected to the considered vertex with only
%         empty vertices between them.
%   Attention! Vertices are references by their number in the old metalanguage object, other-
%   wise problems arise when multiple vertices have the same content. 
%-------------------------------------------------------------------------------------------

if isempty(ML) | strcmpi(ML.Status, 'compact'), MLC = ML;
else,
    MLC.Vertices = [{''}, cellstr(strvcat(ML.Vertices))', {''}];
    OrigVtxNrs   = [1 find(ismember(ML.Vertices, MLC.Vertices(2:end-1))) length(ML)];
    
    NVertices = length(MLC.Vertices);
    for n = 1:NVertices, 
        MLC.Edges{n} = findNEVertices(MLC, ML, OrigVtxNrs, OrigVtxNrs(n)); 
    end
    
    MLC.Status = 'compact';
    
    MLC = metalng('c', MLC);
end

%---------------------------------------local functions---------------------------------------
function NewEdges = findNEVertices(MLC, ML, OrigVtxNrs, idx)

Vertices     = MLC.Vertices(2:end-1);
NewNVertices = length(Vertices)+2;
OldNVertices = length(ML.Vertices);

Edges    = ML.Edges{idx};
NEdges   = length(Edges);
NewEdges = [];

for n = 1:NEdges,
    Edge   = Edges(n);
    Vertex = ML.Vertices{Edges(n)};
    
    if (Edge == OldNVertices), NewEdges = [NewEdges, NewNVertices];    
    elseif isempty(Vertex), NewEdges = [NewEdges, findNEVertices(MLC, ML, OrigVtxNrs, Edge)]; %Recursion ...
    else, NewEdges = [NewEdges, find(ismember(OrigVtxNrs, Edge))]; end
end