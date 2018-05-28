% SGSR version 1.1 declaration file - Sept, 4, 2001
% - complete new calibration protocol and calibdata format;
%   CAV, PRB & PRL ERC menus revisited.
% - standard directories  can be set: "System|Directories" pulldown menu
% - presentation order of FS, LMS, CFS, BFS, BMS and BB fixed to comply
%   with local Farmington traditions.
% - THR menu
% - fixed bug in GetSpikeStats
% - launchAndReturn strategy for stacked dialog launching
% - OK/Cancel by keystrokes (limited scope because of MatLab constraints)

global Versions
Versions.numbers = [Versions.numbers 1.1];
Versions.Dirs{length(Versions.numbers)} = 'vs11';
