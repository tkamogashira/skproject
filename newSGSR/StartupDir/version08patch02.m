% SGSR version 0.8 patch 02 declaration file - Sept, 29, 2000
% cunmulative patch: 01+02
% patch01 (Sept 19):
% - fixed bug in spikehistplot: empty plots crashed
% - fixed bug in noise menus (crashed when right channel only active)
% - implemented "preferred DA range" parameter in System|Local Sys params
% - calibration plots show max SPL values if aaplicable
% - ET1 testing/calibration is only done when recording is requested
% patch02 (Sept 29):
% - added BW/CF-specifying NTD & NSPL stim menus

global Versions
Versions.patches = [Versions.patches, 0.8 + i*0.1*(1:2)];
