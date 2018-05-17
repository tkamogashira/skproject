% method of class @signal
% function sig=generateclicktrain(sig,frequency,[amplitude])
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
%       frequency: frequency of the clicktrain (Hz)
%       amplitude: amplitude [1]
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


function sig=generateclicktrain(sig,frequency,amplitude)

if nargin < 3
    amplitude=1;
end

name= sprintf('Clicktrain %5.2f Hz',frequency);

df=floor(getsr(sig)/frequency);
to=time2bin(sig,getlength(sig));
clicks=1:df:to; % start at the sampletime

sig=setbinvalue(sig,clicks,amplitude);

