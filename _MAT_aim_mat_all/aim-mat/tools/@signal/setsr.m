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


function sig=setsr(sig,sr_neu)
% usage: sig=setsr(a,sr_neu)
% simply sets the sample rate to a fixed value without changing the data!
% if you want to change the samplerate of a signal, that is already there,
% use changesr(sig,new)!


sig.samplerate=sr_neu;
