% method of class @signal
% function sig=crosscorrelate(sig1,sig2,[delay_start],[delay_stop],[normalization_mode])
%
% calculates the cross corrlelation between the signals sig1 and sig2. The
% return value is a signal that covers the correlation between the two
% signals between delay_start and delay_stop.
%
%   INPUT VALUES:
%       sig1: original @signal
%       sig2: @signal to correlate with
%		delay_start: start of the correlation : default -length(sig)
%		delay_stop: longest delay of the correlation : default length(sig)
% 		normalization_mode: normalizateion: default: 'biased' (see help 'xcorr')
% 		
%   RETURN VALUE:
% 		@sig: the correlation values at each delay
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=crosscorrelate(sig1,sig2,delay_start,delay_stop,normalization_mode)

if nargin < 5
	normalization_mode='biased';
end
if nargin < 4
	l1=getlength(sig1);
	l2=getlength(sig2);
	delay_stop=min(l1,l2); % the smaller of both length
end
if nargin < 3
	delay_start=-delay_stop;	% the 
end

% by this time the signal is shifted
deltatime=delay_stop+delay_start;

values1=getvalues(sig1);
values2=getvalues(sig2);

sr=getsr(sig1);
maxlags1=delay_stop*sr;
maxlags2=-delay_start*sr;

maxlags=floor(max(maxlags1,maxlags2));

% do the crosscorrelation:
corrcovs=xcorr(values1,values2,maxlags,normalization_mode);

% return a signal:
sig=signal(corrcovs,sr);
if deltatime > 0
	sig=getpart(sig,deltatime);	% compensate for a possible asymmetric shift
else
	sig=getpart(sig,0,delay_stop-delay_start);	% compensate for a possible asymmetric shift
end
sig=setstarttime(sig,delay_start);
sig=setname(sig,'CrossCorrelation');
sig=setunit_x(sig,'delay (ms)');






