function genpopscript(varargin)
%GENPOPSCRIPT   generate a MATLAB population script
%   GENPOPSCRIPT(ScriptName, S, EntryTemplate) generate a script with the supplied
%   name. If no directory is supplied the current working directory is assumed. The
%   default extension is '.m'. A template for the entries in the population script 
%   must be supplied and should be a string where elements that need to be substituted
%   by values taken from the supplied structure array S are indicated by enclosing the
%   fieldnames of S from which those values need to be taken between dollar signs. 
%   For branched structures fieldnames can be given using the dot as a fieldname 
%   separator. 
%   In the generated popscript, there will be an entry template for every row in the
%   structure array S. All fieldname references in the template will be substituted
%   with the values taken from that row.
%
%   E.g.: Using structure-array from USERDATABASE:
%    genpopscript('popscript', getfield(getuserdata('A0242'), 'CellInfo'), ...
%      sprintf('dsTHR = dataset(''A0242'', $THRSeq$);\nT = CalcTHR(dsTHR);\nD = [D;T];\n'), ...
%       'header', sprintf('echo on;\nD = struct([]);\n'), ...
%       'coda', sprintf('save(mfilename, ''D'');\necho off;\n'))
%   Structure-arrays from DATAQUEST.M (or SERVERQUEST.M) and LOG2LUT.M are also
%   useful.
%
%   Optional properties and their values can be given as a comma-separated list.
%   To view list of all possible properties and their default value, use 'factory' as
%   only input argument.

%B. Van de Sande 08-07-2005

%-----------------------------default parameters------------------------------
DefParam.header    = '';
DefParam.coda      = '';
DefParam.separator = sprintf('\n');

%--------------------------------main program---------------------------------
%Parsing input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    if (nargout == 0), disp('Properties and their factory defaults:'); disp(DefParam);
    else, ArgOut = DefParam; end
    return;
else, [Data, Param] = ParseArgs(DefParam, varargin{:}); end

%Open scriptfile ...
fid = fopen(Param.scriptname, 'w');
if (fid == -1), error(sprintf('''%s'' could not be opened or created.', Param.scriptname)); end

%Write header ...
if ~isempty(Param.header), fprintf(fid, '%s%s', Param.header, Param.separator); end   

%Write entries ...
N = size(Data, 1);
for n = 1:N,
    fprintf(fid, '%s%s', ExpandTemplate(Param.entrytemplate, Data(n, :), Param.fieldnames), ...
        Param.separator);
end

%Write coda ...
if ~isempty(Param.coda), fprintf(fid, '%s', Param.coda); end

%Close scriptfile ...
fclose(fid);

%----------------------------------------------------------------------------
function [Data, Param] = ParseArgs(DefParam, varargin)

%Checking input arguments ...
NArgs = length(varargin); if (NArgs < 3), error('Wrong number of input arguments.'); end
if ~ischar(varargin{1}), error('First argument should be filename of script to be generated.'); end
[Path, FileName, Ext] = fileparts(varargin{1});
if isempty(Path), Path = pwd; end
if isempty(Ext), Ext = '.m'; end
if isempty(FileName), error('First argument should be filename of script to be generated.'); end
ScriptName = fullfile(Path, [FileName, Ext]);
if ~isstruct(varargin{2}), error('Second argument should be structure-array.'); end
[Data, FieldNames] = destruct(varargin{2});
if ~ischar(varargin{3}), error('Third argument should be character string with entry template.'); end
EntryTemplate = ParseExpr(varargin{3}, FieldNames);

%Retrieving properties and checking their values ...
Param = CheckPropList(DefParam, varargin{4:end});
CheckParam(Param);

Param.scriptname    = ScriptName;
Param.entrytemplate = EntryTemplate;
Param.fieldnames    = FieldNames;

%----------------------------------------------------------------------------
function CheckParam(Param)

if ~ischar(Param.header), error('Value of property ''header'' should be a character string.'); end
if ~ischar(Param.coda), error('Value of property ''coda'' should be a character string.'); end
if ~ischar(Param.separator), error('Value of property ''separator'' should be a character string.'); end

%----------------------------------------------------------------------------
function Str = ExpandTemplate(Template, DataRow, FieldNames)

idxFields = find(cellfun('isclass', Template, 'double')); 
FieldNrs = cat(1, Template{idxFields}); NFields = length(FieldNrs);
Template(idxFields) = DataRow(FieldNrs);
Template = cell2cellstr(Template);
Str = cat(2, Template{:});

%----------------------------------------------------------------------------