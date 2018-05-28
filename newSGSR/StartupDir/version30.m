% SGSR version 3.0 declaration file - Apr 2, 2004
%   STIMULUS:
%   restored calibration export 
%   fixed bug in NTD / running noise (reported by Ranjan, Dec 10)
%   adapted param display of "new" params in NTD & NSPL
%   fixed bug in freqsweepcheck occurring in case of a single subseq & log steps
%   fixed storage of log-steps in CFS (Fitz, Aug 11)
%   changed default time window of CDT spike-rate plot from 
%        click duration to stimulus interval.
%   biphasic pulses in CFS, CSPL, CTD (not ICI)
%   describe BERT stim
%
%   ANALYSIS:
%   display more stimulus details in databrowse window
%   display spike stats in histograms etc
%   ability to restrict analysis to subrange of repetitions
%   analysis parameter not stored per dataset; defaults can be set 
%   fixed x-limits in PST hist (Fitz, Aug 11)
%   added option to clear all cache files
%   announce doc on UCrate etc
%   

global Versions
Versions.numbers = [Versions.numbers 3.0];
Versions.Dirs{length(Versions.numbers)} = 'vs30';
