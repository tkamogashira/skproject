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

function spectal_activity=getspektralsum(cframe,nr_from,nr_to)


number=length(cframe);
if number==1
    val=cframe.values;
    sval=val';
    spectal_activity=sum(sum(sval));
else
        not implemented yet
end



