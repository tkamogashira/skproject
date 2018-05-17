% method of class @signal
% function display(sig)
% overwritten function that is called from the shell and for the tooltips
%
%   INPUT VALUES:
%       sig: original @signal
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function display(sig)

if max(size(sig)) > 1
    disp(sprintf('Array of user class Signal with %d signals',max(size(sig))));;
else
    disp('User Signal');
    disp(sprintf('Name: %s',sig.name));
    l=getlength(sig);
    if l > 1
        disp(sprintf('Length=%3.2f sec',getlength(sig)));
    else
        disp(sprintf('Length=%4.1f ms',getlength(sig)*1000));
    end
    disp(sprintf('Points=%d',size(sig.werte,1)));
    disp(sprintf('Samplerate=%5.2f Hz',getsr(sig)));
end