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

function display(fr)

if max(size(fr)) > 1
    disp(sprintf('Array of user class Frames with %d frames',max(size(fr))));;
    disp(sprintf('start time %3.2f ms',getminimumtime(fr(1))*1000));
    disp(sprintf('duration: %3.2f ms',getlength(fr(1))*1000));
	disp(sprintf('samplerate: %3.2f Hz',getsr(fr(1))));
	disp(sprintf('Channels: %d',getnrchannels(fr(1))));
    return
end
    
disp('User Class Frame');
disp(sprintf('start time %3.2f ms',getminimumtime(fr)*1000));
disp(sprintf('duration: %3.2f ms',getlength(fr)*1000));
disp(sprintf('samplerate: %3.2f ms',getsr(fr)));
disp(sprintf('Channels: %d',getnrchannels(fr)));
