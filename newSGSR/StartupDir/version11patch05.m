% SGSR version 1.1 patch 05 declaration file - Nov 12, 2001
% - removed detrend call from readcalib
% - fixed gaussnoiseband calib problems
% - spikes are recorded also during first subseq (PLAYREC)
%
% NOT a cumulative patch! Needs at least patch vs11patch04

global Versions
Versions.patches = [Versions.patches, 1.1 + i*0.5];
