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


function res =getlength(sig)
% returns the length in seconds
    
nr=size(sig.werte,1);
% r1=bin2time(sig,0);
% r2=bin2time(sig,nr);
% res=r2-r1;

sr=getsr(sig);
res=nr/sr;

