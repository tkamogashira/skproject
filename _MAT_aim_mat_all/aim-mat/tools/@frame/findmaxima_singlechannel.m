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

function [heights,maxima] = findmaxima_singlechannel(fr)


for i=1:fr.nr_channels
    channel_data=getsinglechannel(fr,i);
    [heights{i},maxima{i}]=getlocalmaxima(channel_data);
end