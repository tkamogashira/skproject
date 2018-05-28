function Param = checkproplist(DefParam, varargin)
%CHECKPROPLIST  check comma-separated list of properties with their associated values
%   P = CHECKPROPLIST(DF, P1, V1, P2, V2, ...) checks of properties P1, P2, ... 
%   exists as fieldnames in the structure DF, and changes their value to
%   V1, V2, ... The structure with the changed values is returned. 
%   Properties are case insensitive, and the fieldnames in DF are given back as
%   lowercase.
%
%   CHECKPROPLIST(DF, 'list') lists the properties in DF and terminates the program.

%B. Van de Sande 19-3-2003

pvListMessage = 'Additional parameters should be given as property/value list.';

%Check input parameters ...
if (nargin == 0)
    error('Wrong number of input parameters.');
end
if ~isstruct(DefParam)
    error('First argument should be structure with properties and their default values.');
end

%Listing of properties and their default values if desired ...
if (nargin == 2) && ischar(varargin{1}) && strcmpi(varargin{1}, 'list')
    disp('Properties and their default values:');
    disp(lowerfields(DefParam));
    error('Program terminated.');
elseif (nargin == 2) && isstruct(varargin{1})
    Param = comstruct(lowerFields(DefParam), lowerFields(varargin{1}));
    return
elseif mod((nargin-1), 2)
    error(pvListMessage);
end

if nargin == 1
    Param = lowerFields(DefParam);
    return
end

try
    varargin(1:2:end) = lower(varargin(1:2:end));
catch
    error(pvListMessage);
end    

try
    ChangedParam = createstruct(varargin{:});
catch
    error(pvListMessage);
end

try 
    Param = comstruct(lowerFields(DefParam), ChangedParam);
catch
    error('One of the properties isn''t valid'); 
end
