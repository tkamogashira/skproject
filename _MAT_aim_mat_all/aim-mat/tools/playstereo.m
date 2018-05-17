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


function playstereo(sig1,sig2)

sig1=rampamplitude(sig1,0.005);
sig1=scaletomaxvalue(sig1,0.999);
sig2=rampamplitude(sig2,0.005);
sig2=scaletomaxvalue(sig2,0.999);

values1=getvalues(sig1);
values2=getvalues(sig2);

finvals=[values1 values2];
sr=getsr(sig1);

wavwrite(finvals,sr,'last stereo');

sound(finvals,sr);

