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

function fr=setsinglechannel(fr,nr,sig)

if isobject(sig)
    sig_data=getvalues(sig);
else
    sig_data=sig;
end
fr.values(nr,:)=sig_data;
