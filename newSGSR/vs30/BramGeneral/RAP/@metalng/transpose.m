function ML = transpose(ML1) %operator .'
%TRANSPOSE     apply one or more times for metalng objects

%B. Van de Sande 09-10-2003

%-----------------------------------Implementation details--------------------------------- 
%   If the metalng object is empty, this operation doesn't do anything to prevent the 
%   creation of an infinite cycle.
%   For a non empty metalng object, the algorithm goes as follows:
%       1.Add a new source and sink to the metalng object.
%       2.Because of this merging procedure, the existing edges of the object have to be 
%         augmented with one.
%       3.The new source must point to the old source, this is the next element, and the 
%         previous last element must be connected to the new sink and to the old source.
%-------------------------------------------------------------------------------------------

ML = ML1;

if isempty(ML)
    return
else
    N = length(ML);
    
    for n = 1:N
        ML.Edges{n} = ML.Edges{n} + 1;
    end
    ML.Vertices = [{''}, ML.Vertices, {''}];
    ML.Edges = [{2}, ML.Edges, {[]}];
    ML.Edges{N+1} = [ML.Edges{N+1}, 2, N+2];
    
    ML.Status = 'composed';
end