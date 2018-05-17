% method of class @signal
% 
%   INPUT VALUES: instance of signal class
%  
%   RETURN VALUE: kurtosis of signal values
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function m=kurtosis(sig)
% returns the kurtosis of the signal in the WIKIPEDIA-definition (-3)

val=getdata(sig);
m=kurtosis(val)-3;
    
