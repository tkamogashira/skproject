function [C, F] = Destruct(S)
%DESTRUCT   convert branched structure-array to a flat cell-array.
%   [C, F] = DESTRUCT(S) converts branched structure-array S to a 
%   rectangular flat cell-array, i.e a cell-array with the same 
%   number of rows as their are elements in the structure-array and
%   with its number of columns equal to the total number of leaves
%   in the fieldname tree. F is a cell-array of strings containing
%   the expanded fieldnames of S. Branches and leaves in the fieldname
%   tree are separated by dots.

%B. Van de Sande 21-05-2005

%Checking input arguments ...
if (nargin ~= 1) | ~isstruct(S), error('Only input argument should be structure-array.'); end

%Assembling information on structure-array ...
NElem   = length(S);
FNames  = fieldnames(S);
NFields = length(FNames);

%Flatten structure-array ...
[F, C] = deal(cell(0));
for n = 1:NFields,
    Col = eval(sprintf('{S.%s}', FNames{n}))';
    isStruct = cellfun('isclass', Col, 'struct');
    if any(isStruct),
        if ~all(isStruct), error('Invalid structure-array.'); end
        try, Ssub = cat(1, Col{:}); catch, error('Invalid structure-array.'); end
        [Csub, Fsub] = destruct(Ssub); NSubFields = length(Fsub); %Recursion ...
        Fsub = cellstr([repmat([FNames{n} '.'], NSubFields, 1), char(Fsub{:})])';
        F = [F, Fsub]; C = [C, Csub];
    else, F = [F, FNames(n)]; C = [C, Col]; end
end