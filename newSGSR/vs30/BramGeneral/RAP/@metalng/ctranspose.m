function ML = ctranspose(ML1) %operator '
%CTRANSPOSE     apply zero or more times for metalng objects

%B. Van de Sande 09-10-2003

%-----------------------------------Implementation details--------------------------------- 
%   If the metalng object is empty, this operation doesn't do anything to prevent the 
%   creation of an infinite cycle.
%   For a non empty metalng object, the algorithm is simple because this operation is can
%   be defined with other operations:
%                                       L' = ~(L.')
%-------------------------------------------------------------------------------------------

ML = ML1;

if isempty(ML)
    return
else
    ML = ~(ML.');
end