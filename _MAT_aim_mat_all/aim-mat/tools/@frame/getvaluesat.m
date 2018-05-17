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
% $Date: 2003/01/25 12:47:43 $
% $Revision: 1.4 $

function sig=getvaluesat(fr,where,width)
% usage: sig=getvaluesat(fr,nr)
% returns a signal consisting of all points along the frame vertically
% at this point in time

if nargin<3
    width=0;
end

if where> getmaximumtime(fr) | where < getminimumtime(fr)
    error('Frame::getvaluesat time not in range of frame');
end

nrchan=getnrchannels(fr);
for i=1:nrchan
    sig=getsinglechannel(fr,i);
    psig=getpart(sig,where,where+width);
    vals(i)=average(psig);
end

sig=signal(vals);
sig=setsr(sig,1);
sig=setunit_x(sig,'Frequency (kHz)');
sig=setunit_y(sig,'Intervalstrength');
sig=setname(sig,sprintf('Values of Frame at time %3.1f ms',where*1000));
sig=setxlabels(sig,getcf(fr));