% method of class @signal
% function sig=getpart(sig,from,[to])
%
%   INPUT VALUES:
%		@sig: original signal
%		from: from this time in seconds
%		to: to this time in seconds (default: end of signal)
%   RETURN VALUE:
% returns a signal-object that is a copy of the original signal in the 
% range from-to
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=getpart(a,from,to)

sr=getsr(a);

if nargin<3
	to=getlength(a);
end

if from < getminimumtime(a)
    error('error: negative beginning in getpart');
end

if to > getmaximumtime(a)+sr
    error('error: getpart wants part behind signal');
end

duration=to-from;
sig=signal(duration,sr);

target_nr_point=getnrpoints(sig);

start=time2bin(a,from)+1;
stop=time2bin(a,to);

% realtarget=stop-start+1;
% if realtarget~=target_nr_point
% 	% seems to happen when sr=44100
% 	target_nr_point=realtarget;
% end

len=length(a.werte);
if start+target_nr_point-1 > len
	target_nr_point=len-start+1;
 	% seems to happen when sr=44100
	sig.werte(1:target_nr_point)=a.werte(start:start+target_nr_point-1);
else	
	sig.werte(1:end)=a.werte(start:start+target_nr_point-1);
end
% sig.werte(1:end)=a.werte(start:stop);

sig=setstarttime(sig,from);
sig=setname(sig,sprintf('Part of Signal: %s',getname(a)));



