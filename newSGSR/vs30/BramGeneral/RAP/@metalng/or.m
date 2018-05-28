function ML = or(ML1, ML2)
%OR     union for metalng objects

%B. Van de Sande 09-10-2003

%------------------------------Implementation details--------------------------- 
%   If one of the two metalng object is empty, this operation can be interpreted
%   as repeating the item zero or one time, i.e. optional inclusion in the language.
%   For two non empty metalng objects, the algorithm is as follows:
%       1. Merge the vertices of the two objects and add a new source and sink
%          at the beginning and the end.        
%       2. The edges of the two objects have to be changed, because the number of
%          the language elements have been changed by the merging procedure in 1.
%          For the first object this is done by adding the one to all the edges.
%          For the second, all the edges are augmented by the total number of
%          edges in the first metalng object plus one.
%       3. Extra edges have to be created: first of all the old sinks must have
%          an extra connection to the new sink. The new source must have two
%          edges connecting the source to the old sources.
%-------------------------------------------------------------------------------

if ~isa(ML1, 'metalng') || ~isa(ML2, 'metalng')
    error('Union can only be performed between two metalng objects.'); 
end

if isempty(ML1)
    ML = ~ML2;
elseif isempty(ML2)
    ML = or(ML2, ML1);
else
    N1 = length(ML1);
    N2 = length(ML2);
    
    for n = 1:N1
        ML1.Edges{n} = ML1.Edges{n} + 1;
    end
    for n = 1:N2
        ML2.Edges{n} = ML2.Edges{n} + N1 + 1;
    end
    ML1.Edges{N1} = [ML1.Edges{N1}, N1+N2+2];
    ML2.Edges{N2} = [ML2.Edges{N2}, N1+N2+2];
    
    ML.Vertices = [{''}, ML1.Vertices, ML2.Vertices, {''}];
    ML.Edges = [{[2 N1+2]}, ML1.Edges, ML2.Edges, {[]}];
    
    ML.Status = 'composed';
    
    ML = metalng('c', ML);
end