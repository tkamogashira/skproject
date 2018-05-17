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


function val=rms(sig)
%usage: val=rms(data)
%
%returns rms of given vector
%another way would be val=norm(data)/sqrt(length(data))
% David R R Smith   22/05/02

data=getvalues(sig);
val=(mean(data.^2)).^0.5;

