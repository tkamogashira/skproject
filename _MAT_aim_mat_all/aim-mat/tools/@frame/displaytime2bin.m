% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/17 16:57:46 $
% $Revision: 1.3 $

function binx=displaytime2bin(fr,time)
% usage: binx=displaytime2bin(fr,time)
% returns the nr of the bin in the display at this time
% this is shifted due to logarithm etc

srate=getsr(fr);

minimum_time_interval=-fr.display_min_time/1000; % thats the first point we want to see on the screen
maximum_time_interval=fr.display_max_time/1000; % thats the first point we want to see on the screen
binx=(maximum_time_interval+time)*srate+1;

