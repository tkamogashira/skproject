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

function tent=buildtent(fr)

tent=frame(fr);

vals=getvalues(fr);
vals=zeros(size(vals));

nr_chan=getnrchannels(fr);
cfs=getcf(fr);
for i=1:nr_chan
    fre=cfs(i);
    dif=1/fre*2;
    s2=getsinglechannel(fr,i);
    env=envelope(s2,dif,0,0.05);
    vals(i,:)=getvalues(env)';
end

tent=setvalues(tent,vals);

