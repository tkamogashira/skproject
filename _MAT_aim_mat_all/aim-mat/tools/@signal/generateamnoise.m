% method of class @signal
% function sig=genbandpassnoise(sig,varargin)
%   INPUT VALUES:
%       sig: @signal with length and samplerate 
%   RETURN VALUE:
%       sig:  @signal 
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=generateAMnoise(sig,fre,modgrad)

len=getlength(sig);
sr=getsr(sig);

% generate white noise:
vals=getvalues(sig);
vals=rand(size(vals)).*2-1;
sig=setvalues(sig,vals);

envelope=generatesinus(sig,fre,1,0);
envelope=(envelope+1)/2;

sig=sig*envelope;


sig=setname(sig,sprintf('AM noise Frequency %4.1f Hz',fre));

return
