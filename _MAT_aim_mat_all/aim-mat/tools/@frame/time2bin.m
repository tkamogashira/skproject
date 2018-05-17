% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/07/09 15:24:57 $
% $Revision: 1.1 $

function res=time2bin(fr,time)
% gibt das Bin zurück, bei dem diese Zeit wäre
% Zeit immer in Sekunden
% Samplerate immer in Bins pro Sekunde (96 kHz)

samplerate=getsr(fr);

res=time*samplerate;

res=round(res); % rundungsfehler!!!