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


function val=getbinvalue(sig,bin)
% usage: val=gettimevalue(sig,bin)
% returns the value at this bin
% if the time is not exact on one bin, than interpolate 
% correctly

nr_points=getnrpoints(sig);
x=1:nr_points;
Y=sig.werte;
xi=bin;
method='linear';


% val=sig.werte(bin);

val=interp1(x,Y,xi,method);
