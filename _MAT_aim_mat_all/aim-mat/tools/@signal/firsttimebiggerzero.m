% method of class @signal
% function time=firsttimebiggerzero(sig)
%
% returns the time, where the signal is for the first time
% bigger then zero
% useful for throwing away empty parts of signals
%
%   INPUT VALUES:
%       sig: original @signal 
% 
%   RETURN VALUE:
%       time: time, when signal is bigger 0 for first time
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function time=firsttimebiggerzero(sig)

vals=getvalues(sig);
big=find(vals>0);
m=min(big);

time=bin2time(sig,m);

