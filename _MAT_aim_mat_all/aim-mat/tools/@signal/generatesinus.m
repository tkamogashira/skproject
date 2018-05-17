% method of class @signal
% function sig=generatesinus(sig,[fre],[amplitude],[phase])
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       fre: frequency (Hz) [1000]
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


function sig=generatesinus(sig,fre,amplitude,phase)

if nargin < 4
    phase=0;
end
if nargin < 3
    amplitude=1;
end
if nargin < 2
    fre=1000;
end

nr_points=getnrpoints(sig);
sr=getsr(sig);
length=getlength(sig);

von=0+phase;
periode=1/fre;
bis=2*pi*length/periode + phase;


temp=linspace(von,bis,nr_points);
data=sin(temp);

data=data*amplitude;

sig=signal(data);
sig=setsr(sig,sr);
sig=setname(sig,sprintf('Sinus %4.2f kHz',fre/1000));