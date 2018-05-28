function ML = and(ML1, ML2)
%AND    concatenation of two metalng objects

%B. Van de Sande 09-10-2003

%-----------------------------------Implementation details--------------------------------- 
%   If one of the two metalng object is empty, the non empty object is returned. The empty
%   language can therefore be regarded as the neutral element.
%   For two non empty metalng objects, the algorithm is as follows:
%       1. Merge all the vertices of the two objects, also the empty vertices.
%       2. The edges of the second metalng object have to be changed, because the number of
%          the language elements have been changed by the merging procedure in 1. This is 
%          done by adding the total number of vertices to all the edges of the second object.
%       3. The last edge of the first metalng object must have an extra edge. Its vertex must
%          connect to the old source of the second metalng object.
%-------------------------------------------------------------------------------------------

if ~isa(ML1, 'metalng') || ~isa(ML2, 'metalng'),
    error('Concatenation can only be performed between two metalng objects.'); 
end

if isempty(ML1)
    ML = ML2;
elseif isempty(ML2)
    ML = ML1;
else
    N1 = length(ML1);
    N2 = length(ML2);
    
    ML.Vertices = [ML1.Vertices, ML2.Vertices];
    for n = 1:N2
        ML2.Edges{n} = ML2.Edges{n} + N1;
    end    
    ML.Edges = [ML1.Edges, ML2.Edges];
    ML.Edges{N1} = [ML.Edges{N1}, N1+1];
    
    ML.Status = 'composed';
    
    ML = metalng('c', ML);
end