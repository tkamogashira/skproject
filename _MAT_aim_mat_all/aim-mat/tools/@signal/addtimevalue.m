% method of class @signal
% function sig=addtimevalue(sig,time,val)
%usage: sig=addtimevalue(sig,time,val)
% adds the double time value "time" to "val"
%
%   INPUT VALUES:
%       sig:  original @signal
%       time: time in seconds, where the value is added
%       val: value, that is added at time
%    
%   RETURN VALUE:
%       sig: @signal
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=addtimevalue(sig,time,val)

nr=time2bin(sig,time);
sig.werte(nr)=sig.werte(nr)+val;