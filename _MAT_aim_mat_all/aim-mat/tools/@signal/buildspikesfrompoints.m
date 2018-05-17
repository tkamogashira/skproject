% method of class @signal
% function sig=buildspikesfrompoints(sig,xx,yy)
% calculates a @signal from the points in x and y
% the new signal is zero everywhere except from the points in xx
%
%   INPUT VALUES:
%       sig:  original @signal
%       xx: x-values of points
%       yy: y-values of points
%    
%   RETURN VALUE:
%       sig: new @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=buildspikesfrompoints(sig,xx,yy)
% uage: sig=buildspikesfrompoints(sig,xx,yy)
% makes a dot of the hight given in yy at each point given in xx
% all other values =0


sig=mute(sig);

nr_points=length(xx);
for i=1:nr_points
    oldval=gettimevalue(sig,xx(i));
    newval=oldval+yy(i);
    sig=addtimevalue(sig,xx(i),newval);
end


