% method of class @signal
% function sig=genam(sig,fcar,fmod,modgrad)
%
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       fcar: carrier frequency (Hz)
%       fmod: modulation frequency (Hz)
%       modgrad: modulation depth in (0-1)
% 
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=genam(sig,fc,f0,modgrad)


sr=getsr(sig);
len=getlength(sig);

f1=fc-f0;
f2=fc;
f3=fc+f0;


sin1=sinus(len,sr,f1,modgrad/2,0);
sin2=sinus(len,sr,f2,1,0);
sin3=sinus(len,sr,f3,modgrad/2,0);


sig=sin1;
sig=sig+sin2;
sig=sig+sin3;

name=sprintf('AM: modulation: %3.1f Hz, carrier: %4.1f kHz, modgrad: %2.1f',f0,fc/1000,modgrad);
sig=setname(sig,name);
sig=scaletomaxvalue(sig,1);
% sig=RampAmplitude(sig,0.01); % baue eine Rampe

