% SGSR version 0.7 patch 03 declaration file - July, 24, 2000
% patch03 (July 24):
%  - fixed bug in LMScheck reported by Fitz
%  - fixed export option in calibration plots -> most recent graph is exported
%  - improved Stop facility (interruption of D/A)
%  - automatic testing/calibration of ET1
%  - removed ..\OLD\TDT\test from path
global Versions
Versions.patches = [Versions.patches, 0.7 + i*0.3];
