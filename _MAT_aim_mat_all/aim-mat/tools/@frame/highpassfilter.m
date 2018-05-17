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

function fr=highpassfilter(fr,cutoff,dbperoctave);
% usage:fr=highpassfilter(fr,cutoff,dbperoctave);
% filters all channel according to its frequency


nr_chan=getnrchannels(fr);
cfs=getcf(fr);
vals=getvalues(fr);

for i=1:nr_chan
    fre=cfs(i);
    val=getfiltervaluehighpass(fre,cutoff,dbperoctave);
    vals(i,:)=vals(i,:)*val;
end

fr=setvalues(fr,vals);