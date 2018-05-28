function [FileName, Type] = CheckDataFile(FileName)
%CHECKDATAFILE  checks if datafile exist.
%   [FileName, Type] = CheckDataFile(FileName)

%B. Van de Sande 27-03-2003

DirInfo = GetDirInfo('');

%Parameters nagaan ...
if (nargin ~= 1) | ~ischar(FileName), error('Invalid filename.'); end

[OrigPath, FileName, OrigFileExt] = fileparts(FileName);
if isempty(FileName), error('Invalid filename.');
else FileName = upper(FileName); end
%Nagaan of databestand in SGSR of IDF/SPK formaat is ...
if isempty(OrigPath), Path = datadir; else, Path = OrigPath; end
if isempty(OrigFileExt), FileExt = '.log'; else, FileExt = OrigFileExt; end
SGSRFullFileName = fullfile(Path, [FileName FileExt]);
%Nagaan of databestand in DAT formaat is ...
if isempty(OrigPath), Path = DirInfo.MadDataDir; else, Path = OrigPath; end
if isempty(OrigFileExt), FileExt = '.dat'; else, FileExt = OrigFileExt; end
MadFullFileName = fullfile(Path, [FileName FileExt]);

MadType  = exist(MadFullFileName, 'file');
SGSRType = exist(SGSRFullFileName, 'file');

if ~SGSRType & ~MadType
    error(sprintf('%s doesn''t exist.', FileName));
elseif (nargout == 2)
    if MadType, Type = 'MADISON';
    elseif SGSRType, Type = 'SGSR'; end    
end
    