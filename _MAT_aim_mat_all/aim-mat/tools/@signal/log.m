% method of class @signal
% function sig=log(sig)
%   INPUT VALUES:
%       sig: original @signal with length and samplerate 
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



function sig=log(sig)
sig.werte=log(sig.werte);