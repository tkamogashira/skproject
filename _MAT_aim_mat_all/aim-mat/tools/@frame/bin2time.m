% method of class @frame
% function res=bin2time(sig,bin)
% calculates the time according to the value of the bin in
%
%   INPUT VALUES:
%       sig:  original @frame
%       bin: value of bin (not necessary integer)
%    
%   RETURN VALUE:
%       res: time of bin in seconds
%
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/06/11 10:46:32 $
% $Revision: 1.1 $

function res=bin2time(fr,val)
% gibt die Zeit zurück, bei dem dieses Bin ist
% Zeit immer in Sekunden
% Samplerate immer in Bins pro Sekunde (96 kHz)
sr=fr.samplerate;
% eines abgezogen, weil Matlab bei 1 startet also bin 1der Anfangszeitpunkt ist
% res=(val-1)/sr;
res=val/sr;

res=res+fr.start_time;