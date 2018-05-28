function [FullFileName, FileName, ErrTxt] = ParseDataFileName(FileName)
%ParseDataFileName  parse datafile name
%   [FullFileName, FileName, ErrTxt] = ParseDataFileName(FileName) parses 
%   the character string FileName. If no directory is supplied, the standard 
%   data directory is assumed. The default extension is '.LOG' for SGSR datafiles,
%   and '.DAT' for EDF datafiles. This function returns the filename with full 
%   path and extension in FullFileName, the lower case filename of the datafile
%   is returned as FileName.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 16-10-2003

[FullFileName, ErrTxt] = deal('');

FileName = lower(FileName);
[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path)
    Path = dataDir;
end
if isempty(FileName)
    ErrTxt = 'Invalid data filename';
    return;
end
if isempty(FileExt)
    if isEDF(fullfile(Path, FileName))
        FileExt = '.dat';
    else
        FileExt = '.log';
    end
end
FullFileName = fullfile(Path, [FileName FileExt]);
