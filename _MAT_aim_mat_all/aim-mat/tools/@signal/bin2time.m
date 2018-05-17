% method of class @signal
% function res=bin2time(sig,bin)
% calculates the time according to the value of the bin in
%
%   INPUT VALUES:
%       sig:  original @signal
%       bin: value of bin (not necessary integer)
%    
%   RETURN VALUE:
%       res: time of bin in seconds
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function res=bin2time(sig,val)
% gibt die Zeit zurück, bei dem dieses Bin ist
% Zeit immer in Sekunden
% Samplerate immer in Bins pro Sekunde (96 kHz)
sr=sig.samplerate;
% eines abgezogen, weil Matlab bei 1 startet also bin 1der Anfangszeitpunkt ist
% res=(val-1)/sr;
res=val/sr;

res=res+sig.start_time;