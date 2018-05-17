% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function [m,b]=linearfit(sig)
% fit the signal with a streight line and return the slope (m) and the zero
% crossing (b)

y=getvalues(sig);
x=getxvalues(sig);
[p,s] = polyfit(x,y,1);

m=p(1);
b=p(2);
