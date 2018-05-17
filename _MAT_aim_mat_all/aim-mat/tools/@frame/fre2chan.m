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

function chan=fre2chan(fr,fre)
% returns the channel-nr of that frequency

fres=getcf(fr);
x=fres;
Y=1:getnrchannels(fr);
xi=fre;
method='linear';

chan=interp1(x,Y,xi,method);