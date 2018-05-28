function DataFile = CheckMadisonDataFile(FileName)

%------------------------------------------------%
% Oorspronkelijk behorende bij het OSCOR-project %
%------------------------------------------------%

DataFile = struct([]);
DirInfo  = getdirinfo;

if nargin < 1, error('Wrong number of input parameters'); end

[Path, FileName, FileExt] = fileparts(upper(FileName));
if isempty(Path), Path = DirInfo.MadDataDir; end
if isempty(FileName), error('Datafile doesn''t exist'); end
if isempty(FileExt), FileExt = '.DAT'; end
TableExt = '.TABLE'; ConvExt  = '.CONV';

if ~exist(fullfile(Path, [FileName FileExt]), 'file')
    error('Datafile doesn''t exist');
end

DataFile = CollectInStruct(Path, FileName, FileExt, TableExt, ConvExt);
