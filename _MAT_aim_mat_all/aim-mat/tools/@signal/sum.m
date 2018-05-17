% method of class @
%function s=sum(sig,t_start,t_stop) 
%   INPUT VALUES:
%  	sig: @signal
%	t_start: start time (default: 0)
% 	t_stop: sum until here (default: signal-length)
%
%   RETURN VALUE:
%		s: sum of the signal in that region
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function s=sum(sig,t_start,t_stop)

if nargin < 2
    t_start=getminimumtime(sig);
end
if nargin < 3
    t_stop=getmaximumtime(sig);
end

intstart=time2bin(sig,t_start)+1;
intstop=time2bin(sig,t_stop);


if intstart<1
    intstart=1;
    disp('signal::sum: starttime too small');
end
if intstop>getnrpoints(sig)
    intstop=getnrpoints(sig);
    disp('signal::sum: intstop too big!');
end

% if intstart>intstop
%     error('signal::sum: stoptime < starttime');
% end


s=sum(sig.werte(intstart:intstop));