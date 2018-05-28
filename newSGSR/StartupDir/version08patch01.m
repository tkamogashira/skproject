% SGSR version 0.8 patch 01 declaration file - Sept, 19, 2000
% patch01 (July 19):
% - fixed bug in spikehistplot: empty plots crashed
% - fixed bug in noise menus (crashed when right channel only active)
% - implemented "preferred DA range" parameter in System|Local Sys params
% - calibration plots show max SPL values if aaplicable
% - ET1 testing/calibration is only done when recording is requested

global Versions
Versions.patches = [Versions.patches, 0.8 + i*0.1*(1:1)];
