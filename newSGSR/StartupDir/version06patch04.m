% SGSR version 0.6 patch 03 declaration file - May, 19, 2000
% cumulative patch
% patch01 (May 11):
% - Fixed bug in stimstats: ignoring zero ipool values 
%   of subseq struct
% patch02:
% - fixed order of openuimenu/declaremenudefaults in all 
%   initXXXmenu functions
% - fscheck uses standard uigroup checkers like 'FrequencySweepCheck'
% patch03:
% - fixed contraChannel tag in WAVmenu.fig so that UpdateStimMenuHeader
%   doesn't crash
% patch04:
% - BFS stimulus menu

global Versions
Versions.patches = [Versions.patches, 0.6 + i*0.1*(1:4)];
