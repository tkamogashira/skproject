function Val = Try2ExtractVF(ds, VirtualFName)
%TRY2EXTRACTVF   try to extract virtual fieldname from dataset.
%   V = TRY2EXTRACTVF(ds, FName) tries to extract the value of
%   the specified virtual fieldname FName from the dataset 
%   object ds. When FName is a cell-array of strings then these
%   fieldnames are tried succesively.

%B. Van de Sande 27-07-2004

%Checking input parameters ...
if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~isa(ds, 'dataset') | ~(ischar(VirtualFName) | iscellstr(VirtualFName)),
    error('Wrong input arguments.');
end

VirtualFName = cellstr(VirtualFName); N = length(VirtualFName); 
for n = 1:N,
    try, Val = eval(sprintf('ds.%s;', VirtualFName{n})); return;
    catch, lasterr(''); end
end
Val = NaN;