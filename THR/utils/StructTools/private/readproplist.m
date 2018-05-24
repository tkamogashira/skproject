function Param = readproplist(FileName, DefParam)
%READPROPLIST  reads list of properties and their corresponding values from file
%   P = READPROPLIST(FN, DP) reads properties and associated values from filename FN. If no directory
%   is given the current working directory is assumed. The default extension is .cfg. The allowed properties
%   and their standard values should be given as a scalar structure DP. Properties are case insensitive.
%   
%   A configuration file is a standard textfile with every line giving a property and its value, separated by 
%   an equal sign. Cell-array elements should be separated by a comma and enclosed between curly braces. Character 
%   strings should be enclosed between quotes.
%
%   See also CHECKPROPLIST

%B. Van de Sande 03-07-2003

if nargin ~= 2, error('Wrong number of input arguments.'); end
if ~isstruct(DefParam) | length(DefParam) ~= 1, error('Second argument should be structure with properties and their default values.'); end

[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path), Path = pwd; end
if isempty(FileName), error('Invalid filename.'); end
if isempty(FileExt), FileExt = '.cfg'; end
FullFileName = fullfile(Path, [FileName FileExt]);

if ~exist(FullFileName), Param = lowerfields(DefParam); return; end

[Props, Values] = textread(FullFileName, '%s%s', 'delimiter', '=');

Props = fulldeblank(Props);
Values = local_parse(Values);

PropList = [Props'; Values']; PropList = PropList(:)';
Param = checkproplist(DefParam, PropList{:});

%---------------------------------locals------------------------------------
function V = local_parse(V)

N = length(V);
for n = 1:N, 
    try V{n} = eval(V{n}); 
    catch, error('Syntax error in configuration file.'); end    
end    

