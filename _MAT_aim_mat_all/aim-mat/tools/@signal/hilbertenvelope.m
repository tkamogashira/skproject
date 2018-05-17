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


function sig=hilbertenvelope(a)

sr=getsr(a);
duration=getlength(a);

sig=signal(duration,sr);
sig.name=sprintf('Hilbert Envelope of %s',a.name);

b=hilbert(a.werte);
sig.werte=abs(b);