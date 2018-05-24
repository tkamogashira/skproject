function Nr = AssessNrOfAnimals(S, IdFName, IncRowNrs)

%B. Van de Sande 14-03-2005

%Checking input arguments ...
if ~isstruct(S), error('First argument should be structure-array.'); end
[Data, FNames] = destruct(S);
if ~ischar(IdFName) | ~ismember(IdFName, FNames), error('Second argument should be valid fieldname.'); end
N = length(S);
if (nargin == 2), IncRowNrs = 1:N;
elseif ~isnumeric(IncRowNrs) | ~all(ismember(IncRowNrs, 1:N)), 
    error('Optional third argument should be numerical vector with row numbers of structure-array.');
end

%Estimate number of animals. The number of animals is estimated by the number of
%middle numbers in the filenames. E.g. C0214 and A0214B are collected from the same
%animal ...
idx = find(ismember(FNames, IdFName));
FileNames = char(Data(IncRowNrs, idx));
FileNames = unique(char2num(FileNames(:, [2:end]), 1), 'rows');
if (length(FileNames) == 1) & isnan(FileNames), Nr = 0;
else, Nr = length(FileNames); end