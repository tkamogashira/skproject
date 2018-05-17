% method of class @signal
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


function ret=sig2simulinkinput(sig)
% wandelt das signal sig in eine Struktur um, die Simulink lesen kann

sr=getsr(sig);
len=getlength(sig);

ret.time=(1/sr:1/sr:len)';
ret.signals(1).values=getvalues(sig);
ret.signals(1).dimensions=1;

