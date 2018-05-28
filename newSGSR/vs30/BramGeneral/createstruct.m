function S = createstruct(varargin)
%CREATESTRUCT creates struct from comma-separated list of fieldnames and values
%   S = CREATESTRUCT(FieldName1, FieldValue1, ...) creates structures S with fieldnames FieldName1, ... and
%   values FieldValue1, ... .
%   Attention! This function is different from STRUCT in that a fieldname can have a value that is of type
%   cell-array. STRUCT interprets a cell-array as different values for the same field in a struct-array.
%
%   See also STRUCT

%B. Van de Sande 24-03-2003

if isempty(varargin), error('Wrong number of input arguments.');
elseif (length(varargin) == 1) & isa(varargin{1}, 'struct'), S = varargin{1};
elseif mod(length(varargin),2) == 0
    PropList  = varargin(1:2:end);
    ValueList = varargin(2:2:end);
    
    PropList   = VectorZip(PropList, repmat({[]}, 1, length(PropList)));
    S = struct(PropList{:});
    
    FNames     = fieldnames(S);
    NFields    = length(FNames);
    
    for n = 1:NFields
        S = setfield(S, FNames{n}, ValueList{n});
    end
else, error('Field and value input arguments must come in pairs.'); end    