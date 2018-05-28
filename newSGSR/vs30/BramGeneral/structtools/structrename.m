function S = structrename(varargin)
%STRUCTRENAME   rename fieldnames of a structure-array.
%   S = STRUCTRENAME(S, OldFNames, NewFNames)
%   S = STRUCTRENAME(S, FNames)

%B. Van de Sande 14-08-2005

%Checking input arguments ...
if ~any(nargin == [2, 3]), error('Wrong number of input arguments.'); end
if ~isstruct(varargin{1}), error('First argument should be structure-array.'); end
[Data, FNames] = destruct(varargin{1});

%Renaming the fieldnames ...
if (nargin == 3),
    if ~ischar(varargin{2}) & ~iscellstr(varargin{2}),
        error('Fieldnames must be supplied as character string or cell-array of strings.'); 
    end
    OldFNames = cellstr(varargin{2}); Nold = prod(size(OldFNames));
    if ~all(ismember(OldFNames, FNames)),
        error('One of the supplied fieldnames to rename doesn''t exist.');
    end    
    if ~ischar(varargin{3}) & ~iscellstr(varargin{3}),
        error('Fieldnames must be supplied as character string or cell-array of strings.'); 
    end
    NewFNames = cellstr(varargin{3}); Nnew = prod(size(NewFNames));
    if (Nold ~= Nnew), error('Fieldname lists must be of equal length.'); end
    for n = 1:Nnew, FNames(find(ismember(FNames, OldFNames{n}))) = NewFNames(n); end
elseif (nargin == 2),
    if ~ischar(varargin{2}) & ~iscellstr(varargin{2}),
        error('Fieldnames must be supplied as character string or cell-array of strings.'); 
    end
    FNames = cellstr(varargin{2});
    if (length(FNames) ~= size(Data, 2)), error('Wrong number of fieldnames supplied.'); end
end
S = construct(Data, FNames);