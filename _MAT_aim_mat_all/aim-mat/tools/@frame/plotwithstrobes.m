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

function plotwithstrobes(nap,allstrobeprocesses)

plot(nap);
sr=getsr(nap);hold on
nr_channels=getnrchannels(nap);
start_time=getminimumtime(nap);
for i=1:nr_channels
    nr_strobes=length(allstrobeprocesses{i}.strobes);
    for j=1:nr_strobes
        x=time2bin(allstrobeprocesses{i}.strobes(j)-start_time,sr);
        y=i;
        z=allstrobeprocesses{i}.strobe_vals(j);
        plot3(x,y,z,'.r');hold on
    end
        
end
