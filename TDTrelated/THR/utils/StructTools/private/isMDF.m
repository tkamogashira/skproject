function boolean = isMDF(DFN)
%ISMDF  checks if datafile is of type MDF
%   boolean = ISMDF(DFN)

%Bram Van de Sande 05-04-2004

if nargin ~= 1, error('Wrong number of input arguments.'); end

[Path, FileName, FileExt] = fileparts(DFN);
if isempty(Path), Path = dataDir; end
if strcmpi(FileExt, '.LOG') | isempty(FileExt), FileExt = '.MDF'; end
if isempty(FileName), boolean = logical(0);
else, 
    FullFileName = fullfile(Path, [FileName, FileExt]);
    if strcmpi(FileExt, '.MDF') &  exist(FullFileName, 'file'), boolean = logical(1);
    else, boolean = logical(0); end
end