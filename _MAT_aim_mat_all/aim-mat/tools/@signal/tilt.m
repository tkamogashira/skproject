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



% not jet fully tested!!!



function sig=tilt(sig,tilttime)
% usage: sig=tilt(sig,tilttime)
% puts the signal downwards to the left!
% in the auditory image model, all activities become
% smaller with the distance
% usually with a decrease of 100% in 40 ms





if nargin<2
    tilttime=0.04;
end

vals=sig.werte;

if getminimumtime(sig)>0
    return
end
durationtotilt=abs(getminimumtime(sig));
tiltnr=time2bin(sig,0); % so viele Punkte werden getiltet
dt=tilttime-durationtotilt; % übrige Zeit, die links aus dem Bild rausgeht
dnull=dt/tilttime;
ti=linspace(dnull,1,tiltnr)';
vals(1:tiltnr)=vals(1:tiltnr).*ti;
% figure
% subplot(2,1,1)
% plot(sig);
sig.werte=vals;
% subplot(2,1,2)
% plot(sig);



