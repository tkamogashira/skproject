% SGSR version 0.6 patch 02 declaration file - May, 16, 2000
% cumulative patch
% patch01 (May 11):
% - Fixed bug in stimstats: ignoring zero ipool values 
%   of subseq struct
% patch02:
% - fixed order of openuimenu/declaremenudefaults in all 
%   initXXXmenu functions
% - fscheck uses standard uigroup checkers like 'FrequencySweepCheck'

global Versions
Versions.patches = [Versions.patches, 0.6 + i* 0.1, 0.6 + i* 0.2];
