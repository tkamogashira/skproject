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

function sumsig=getweightedintervalsum(cframe,gauss)
% usage: spectal_activity=getweightedspektralsum(cframe,gauss)
% returns the sum over frequency as function of interval
% the frame is weighted by "gauss"


number=length(cframe);
if number==1
    val=cframe.values;
    sval=val';
    gava=getvalues(gauss);
    for i=1:getnrpoints(cframe)
        sval(i,:)=sval(i,:).*gava';
    end
    intervals=sum(sval');

    sumsig=signal(intervals);
    sumsig=setsr(sumsig,getsr(cframe));
    sumsig=setname(sumsig,sprintf('Weighted sum of Frame: %s',getname(cframe)));
    sumsig=setstarttime(sumsig,getminimumtime(cframe));
    
    
else
        not implemented yet
end

