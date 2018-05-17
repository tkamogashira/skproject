% method of class @
%function sig=uminus(sig,b) 
%   INPUT VALUES:
%  		sig: original signal
%   RETURN VALUE:
%		sig: inverted signal
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=uminus(a,b)
%Vorzeichenwechsel
sig=a;
sig.werte= -sig.werte;
