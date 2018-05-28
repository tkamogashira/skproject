function [FullFileName, FileName, FileExt] = parseEDFFileName(FileName)

%B. Van de Sande 10-03-2004

[Path, FileName, FileExt] = fileparts(lower(FileName));

%Using the current browsing directory of DATABROWSE as default directory ...
if isempty(Path), Path = bdataDir; end

%If extension is .LOG, then converting extension to '.DAT' for reasons of consistency with SGSR ...
if isempty(FileExt) || strcmpi(FileExt, '.log')
    FileExt = '.dat';
end

if isempty(FileName)
    FullFileName = '';
else
    FullFileName = fullfile(Path, [FileName FileExt]);
end
