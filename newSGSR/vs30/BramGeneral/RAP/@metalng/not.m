function ML = not(ML1)
%NOT    apply zero or one times for metalng objects

%B. Van de Sande 09-10-2003

%-----------------------------------Implementation details--------------------------------- 
%   If the metalng object is empty, this operation doesn't do anything to prevent the 
%   creation of an infinite cycle.
%   For a non empty metalng object, the algorithm is simple to add an extra edge to the
%   source pointing to the sink. Except if this edge is already present.
%-------------------------------------------------------------------------------------------

ML = ML1;

if isempty(ML)
    return
else     
    N = length(ML);
    if ~ismember(N, ML.Edges{1}), 
        ML.Edges{1} = [ML.Edges{1}, N]; 
        ML.Status   = 'composed';
    end
end