% method of class @signal
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

function sig=modtuningtilt(sig)

sig=antitilt(sig,0.04); % mache die Neigung rückgängig


sig=tilt(sig,0.08); % tilte, aber etwas weniger



vals=sig.werte;


cutoff=500; % Hz
drop=0.002; % Falle bis auf Null in 2 ms
durationtotilt=1/cutoff; 

tiltstart=time2bin(sig,-durationtotilt);  % Hier gehts los
tiltend=time2bin(sig,-durationtotilt+drop);        % und hier hörts schon wieder auf
tiltnr=tiltend-tiltstart;
ti=linspace(1,0,tiltnr);

vals(tiltstart+1:tiltend)=vals(tiltstart+1:tiltend).*ti(:);
vals(tiltend:end)=0;
% figure
% subplot(2,1,1)
% plot(sig);
sig.werte=vals;
% subplot(2,1,2)
% plot(sig);

