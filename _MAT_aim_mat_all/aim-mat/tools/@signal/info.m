% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function info(sig)
disp(sprintf('Name:       %s',sig.name));
disp(sprintf('Length:     %5.2f ms',GetLength(sig)*1000));
disp(sprintf('Points:     %d',size(sig.werte,1)));
disp(sprintf('Samplerate: %5.2f kHz',sig.samplerate/1000));
disp(sprintf('Unit X:     %s',sig.unit_x));
disp(sprintf('Unit Y:     %s',sig.unit_y));
disp(sprintf('Start time: %5.2f sec',sig.start_time));

