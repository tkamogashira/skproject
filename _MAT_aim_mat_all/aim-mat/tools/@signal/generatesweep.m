% method of class @signal
% function sig=generatesweep(sig,fre1,fre2,amplitude,phase)
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       fre1: start frequency (Hz)
%       fre2: stop frequency (Hz)
%       amplitude: [1]
%       phase: startphase [0]
%       phases must be in degrees!
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=generatesweep(sig,fre1,fre2,amplitude,phase)

if nargin < 5
    phase=0;
end
if nargin < 4
    amplitude=1;
end

if nargin <3 
    disp('GenerateSweep: Error: usage: sig=generatesweep(sig,fre1,fre2[,amplitude,phase])')
end

nr_points=getnrpoints(sig);
sr=getsr(sig);
length=getlength(sig);

from=0+phase;

fre_space=linspace(fre1,fre2,nr_points);    % the change of frequency
t_space=linspace(0,length,nr_points);    % a linear function of time
val=2*pi*t_space.*fre_space;

val=val + phase;

data=sin(val);

data=data*amplitude;

sig=signal(data);
sig=setsr(sig,sr);
sig=setname(sig,sprintf('Sweep from %4.2f kHz to %4.2f kHz',fre1/1000,fre2/1000));