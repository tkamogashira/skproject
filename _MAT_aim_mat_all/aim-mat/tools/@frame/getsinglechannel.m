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

function sig=getsinglechannel(fr,nr)

channel_data=fr.values(nr,:);
sig=signal(channel_data);


sig=setsr(sig,fr.samplerate);
sig=setstarttime(sig,fr.start_time);
sig=setunit_x(sig,'interval (ms)');

cfs=getcf(fr);
mycf=cfs(nr);

if mycf<1000
    sig=setname(sig,sprintf('Channel %d - CF: %4.0f Hz',nr,mycf));
else
    sig=setname(sig,sprintf('Channel %d - CF: %2.2f kHz',nr,mycf/1000));
end
