% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function sig=createfrompoly(sig,p)
% creates the signal from the points in the polynoms p (very useful with
% polynomes that come from a fit

sr=getsr(sig);
xvals=getxvalues(sig);
pvals=polyval(p,xvals);
sig=setvalues(sig,pvals);