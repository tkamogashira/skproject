% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003-2008, University of Cambridge, Medical Research Council 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function res=bin2time(bin,samplerate)
% gibt die Zeit zurück, bei dem dieses Bin ist
% Zeit immer in Sekunden
% Samplerate immer in Bins pro Sekunde (96 kHz)

res=bin/samplerate;