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
% $Date: 2003/01/31 17:44:34 $
% $Revision: 1.1 $

function fr=reverse(frorg)

dat=getvalues(frorg);
dat=dat(:,end:-1:1);

fr=setvalues(frorg,dat);






