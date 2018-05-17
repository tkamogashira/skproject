% method of class @signal
%
%   INPUT VALUES:
%  sig,attenuation,ramp
% sig is the signal or a array of two signals for stereo
% attenuation is the attenuation against the lowdest possible tone
% with amplitude =1
% default=1
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


% function play(sig,attenuation,ramp)
function play(sig,attenuation,ramp)

if nargin < 3
    ramp=0;
end
if nargin < 2
    attenuation=0;
end
    if attenuation > 0
        % 	error('cant play sounds louder then maximum, reduce attenuation!');
        disp('warning: signal\play:: play sounds louder then maximum, reduce attenuation!');
    end

if length(sig)>1 % stereo!
    sig(1)=attenuate(sig(1),attenuation);
    sig(2)=attenuate(sig(2),attenuation);

    values1=getvalues(sig(1));
    values2=getvalues(sig(2));
    
    finvals=[values1 values2];
    sr=getsr(sig(1));
    
    sound(finvals,sr);
    pause(getlength(sig(1)));
else
    
    
    % beware of playing a NULL-stimulus!
    if getlength(sig)<=1/getsr(sig)
        return
    end
    
    if ramp>0
        sig=rampamplitude(sig,ramp);
    end
    
    sig=attenuate(sig,attenuation);
    
    if max(sig)>1
        disp('warning: signal\play:: clipping in signal');
    end
    sound(sig.werte,sig.samplerate);
    
    pause(getlength(sig));
end