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

function sumsig=getweightedsum(fr,cutoff,db_per_octave,von,bis)
% weights the frequency with some function (usually lowpass)

if nargin<5
    bis=getnrchannels(fr);
end
if nargin < 4
    von=1;
end

if nargin < 2
    cutoff=4000;
end
if nargin < 3
    db_per_octave=6;  % quality above
end


% number=getnrchannels(fr);
cfs=getcf(fr);

samplesig=getsinglechannel(fr,1);
sumsig=signal(samplesig);
sumsig=mute(sumsig);
sumsig=setname(sumsig,sprintf('weighted sum of frame: %s',getname(fr)));

for i=von:bis
    sig=getsinglechannel(fr,i);
    cur_fre=cfs(i);
    scaler=getfiltervalue(cur_fre,cutoff,db_per_octave);    

    sig=sig*scaler;
    sumsig=sumsig+sig;

end
