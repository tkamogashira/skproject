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

function disp(fr)

disp(sprintf('start time %3.2f ms',getminimumtime(fr)*1000));
disp(sprintf('duration: %3.2f ms',getlength(fr)*1000));
disp(sprintf('samplerate: %3.2f ms',getsr(fr)));
disp(sprintf('Channels: %d',getnrchannels(fr)));
