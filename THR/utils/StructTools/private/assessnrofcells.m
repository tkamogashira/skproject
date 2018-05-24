function Nr = AssessNrOfCells(S, IdFName, IncRowNrs)

%B. Van de Sande 23-03-2005

%Checking input arguments ...
if ~isstruct(S), error('First argument should be structure-array.'); end
[Data, FNames] = destruct(S);
if ~iscellstr(IdFName) | ~all(ismember(IdFName, FNames)), error('Second argument should be valid cell-array of fieldnames.'); end
N = length(S);
if (nargin == 2), IncRowNrs = 1:N;
elseif ~isnumeric(IncRowNrs) | ~all(ismember(IncRowNrs, 1:N)), 
    error('Optional third argument should be numerical vector with row numbers of structure-array.');
end

%Conversion to strings doesn't give any problems when comparing entries, cause
%comparisons are only made within the same table ... There could be a problem
%when comparing multiple tables, cause then the alignment of columns could give 
%rise to restricted matchings ...
%A real problem is the reduced accuracy with which floating points are compared!
List = upper(cv2str(Data(IncRowNrs, find(ismember(FNames, IdFName)))));
Nr = size(unique(List, 'rows'), 1);