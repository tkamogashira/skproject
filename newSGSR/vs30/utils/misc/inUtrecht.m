function iu=inUtrecht;
% INUTRECHT - returns true if in utrecht
global StartupDir
iu = isequal(7,exist('E:\ToLeuven')) & ~isequal('d:\testsgsr\startupdir', lower(StartupDir));
iu = iu | exist('c:\CelsLapTop.txt', 'file');

