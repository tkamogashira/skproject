% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function vals=getxvalues(sig)
% return all x values of the signal in one vector

sr=getsr(sig);
time_null=getminimumtime(sig);
time_max=getmaximumtime(sig);
vals=[time_null:1/sr:time_max];
% correction:
vals=vals(1:length(getvalues(sig)));
vals=vals';