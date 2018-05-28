function [FullFileName, FileName, ErrTxt] = ParseMCOFileName(RAPStat, MacroFileName)
%ParseMCOFileName  parse macro filename
%   [FullFileName, FileName, ErrTxt] = ParseMCOFileName(RAPStat, MacroFileName) 
%   parses the character string MacroFileName. The default extension is '.MCO'. 
%   If no directory is supplied, RAP looks in the MATLAB path.
%   This function returns the filename with full path and extension in FullFileName, 
%   the lower case filename of the macro is returned as FileName.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-03-2004

[FullFileName, FileName, ErrTxt] = deal('');

MacroFileName = lower(MacroFileName);
[Path, FileName, FileExt] = fileparts(MacroFileName);
if isempty(FileName), ErrTxt = 'Invalid macro filename'; return; end
if isempty(FileExt), FileExt = '.mco'; end
if isempty(Path) && exist([FileName, FileExt], 'file'), Path = fileparts(which([FileName, FileExt])); end 
if isempty(Path), ErrTxt = sprintf('%s doesn''t exist', MacroFileName); return; end
FullFileName = fullfile(Path, [FileName FileExt]);