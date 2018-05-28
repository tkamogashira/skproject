function ArgOut = structdisp(S, varargin)
%STRUCTDISP display structure array on command window.
%   STRUCTDISP(S) displays the structure array S on the command window.
%   Str = STRUCTDISP(S) returns the output as the character array Str
%   instead of displaying the information.
%
%   STRUCTDISP can be used to load a structure-array in a Microsoft Excel
%   spreadsheet. E.g.:
%       fid = fopen('dump.txt', 'w');
%       fprintf(fid, '%s', structdisp(S)'); %Tranpose operation is necessary!
%       fclose(fid);
%   The file dump.txt can then be loaded into Excel via opening a TAB-
%   delimited textfile.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also STRUCTFIELD, STRUCTSORT, STRUCTFILTER, STRUCTMERGE and STRUCTVIEW

%B. Van de Sande 08-07-2005

%------------------------------default parameters---------------------------
DefParam.fields        = {};
DefParam.indexrow      = 'on'; %'on' or 'off' ...
DefParam.emptyformat   = '';
DefParam.charstrformat = '';
DefParam.integerformat = '%.0f';
DefParam.flpointformat = '%.3f';
DefParam.unknownformat = '<invalid>';

%--------------------------------main program-------------------------------
%Checking input arguments ...
if (nargin == 1) & ischar(S) & strcmpi(S, 'factory'),
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return;
elseif (nargin == 0) | ~isstruct(S), error('Wrong input arguments.'); end
Param = CheckPropList(DefParam, varargin{:});
Param = CheckParam(Param);

%Reorganizing the structure array ...
if isempty(S), error('Empty structure-array.'); end
try [C, F] = destruct(S); catch, error('Structure-array is not valid.'); end
NFields = length(Param.fields);
if (NFields > 0),
    if ~all(ismember(Param.fields, F)), error('One of the requested fieldnames doesn''t exist.'); end
    for n = 1:NFields, idx(n) = find(ismember(F, Param.fields{n})); end
    F = F(idx); C = C(:, idx);
end
if strcmpi(Param.indexrow, 'on'), NRow = size(C, 1); F = [{'RowIdx'}, F]; C = [num2cell(1:NRow)', C]; end

%Formating elements of table and converting all elements to character strings ...
Str = cv2str(cell2cellstr([F; C], 'coloriented', 'yes', 'emptyformat', Param.emptyformat, ...
   'charstrformat', Param.charstrformat, 'integerformat', Param.integerformat, ...
   'flpointformat', Param.flpointformat, 'unknownformat', Param.unknownformat));
    
if (nargout > 0), ArgOut = Str; else, disp(Str); end

%---------------------------local functions------------------------
function Param = CheckParam(Param)

if ~iscellstr(Param.fields) & ~ischar(Param.fields), error('Invalid value for property fields.'); end
Param.fields = cellstr(Param.fields); 
if ~any(strcmpi(Param.indexrow, {'on', 'off'})), error('Property indexrow must be ''on'' or ''off''.'); end

%------------------------------------------------------------------