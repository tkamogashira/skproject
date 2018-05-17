% method of class @
%function bin=time2bin(sig,time) 
%   INPUT VALUES:
%  		sig: @signal
%		time: time in seconds
%   RETURN VALUE:
%		bin: interpolated bin value of that time in the signal corrected by
%		the signals start time
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function ret=time2bin(sig,time)
% returns the real value of the times in bins in the signal. This must not
% be the value that is needed to plot! (see time2plotbin)



time=time-sig.start_time;

ret=time*sig.samplerate;
ret=round(ret); 
