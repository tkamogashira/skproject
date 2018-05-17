% method of class @frame
%
%   Accummulates the signal between "fromchannel" and "tochannel"
% 
%   INPUT VALUES:
%           
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/31 19:51:07 $
% $Revision: 1.5 $

function sumsig=getsum(fr,fromchannel,tochannel)


if nargin<3
    tochannel=getnrchannels(fr(1));
end
if nargin < 2
    fromchannel=1;
end


number=max(size(fr));
if number==1
    val=fr.values;
    l=getlength(fr);
    sr=getsr(fr);
	if getnrchannels(fr)>1
		summe=sum(val(fromchannel:tochannel,:));
	    sumsig=signal(summe);
	 	sumsig=setsr(sumsig,sr);
	    sumsig=setname(sumsig,sprintf('Sum of Frame: %s',getname(fr)));
 		sumsig=setstarttime(sumsig,getminimumtime(fr));
	else 
		sumsig=getsinglechannel(fr,1);
	end    
else
    for e=1:number
        
        val=fr(e).values;
        
        l=getlength(fr(e));
        sr=getsr(fr(e));
        
        summe(e)=sum(val(fromchannel:tochannel,:));
        
        sumsig(e)=signal(summe);
        sumsig(e)=setsr(sumsig(e),sr);
        
        sumsig(e)=setstarttime(sumsig(e),getminimumtime(fr(e)))
        
    end
end
