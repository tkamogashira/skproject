% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function res=time2bin(time,samplerate)
% gibt das Bin zurück, bei dem diese Zeit wäre
% Zeit immer in Sekunden
% Samplerate immer in Bins pro Sekunde (96 kHz)

res=time*samplerate;

res=round(res); % rundungsfehler!!!