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

function ret=frame2simulinkinput(fr)
% wandelt den kompletten Frame fr in eine Struktur um, die Simulink lesen kann

sr=getsr(fr);
len=getlength(fr);

nr_chan=getnrchannels(fr);

ret.time=(1/sr:1/sr:len)';
%for i=1:nr_chan
%    sig=getsinglechannel(fr,i);
%    ret.signals(i).values=getvalues(sig);
%    ret.signals(i).dimensions=1;
%end

vals=getvalues(fr);
ret.signals.values=vals';
ret.signals.dimensions=size(vals,1);
