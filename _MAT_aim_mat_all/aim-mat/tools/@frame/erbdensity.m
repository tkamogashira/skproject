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
% $Date: 2003/02/18 18:37:20 $
% $Revision: 1.1 $


function erb_density=erbdensity(fr)
cfs=getcf(fr);
nr_chan=getnrchannels(fr);
erb1=21.4*log10(4.73e-3*cfs(1)+1);  % from Glasberg,Moore 1990
erb2=21.4*log10(4.73e-3*cfs(nr_chan)+1);
nr_erbs=erb2-erb1;
erb_density=nr_chan/nr_erbs;