% SGSR version 3.0 patch 09 declaration file - 25 October 2005
% - fixed bug in setCalibParams (no crash when setup file is absent)
% - restored "online" rasterplot; upgraded online raster & pst plots to match with uc* analyses
%
% cumulative patch

global Versions
Versions.patches = [Versions.patches, 3.0 + i*0.1*(1:9)];
