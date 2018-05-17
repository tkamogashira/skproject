% method of class @signal
% function sig=abs(sig)
% calculates the abs value of the signal
%
%   INPUT VALUES:
%       sig:  original @signal
%    
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=abs(sig)

s=abs(sig.werte);
sig.werte=s;

