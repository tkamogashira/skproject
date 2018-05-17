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


function sig=mrdivide(sig,b)
% division ist einfach multiplikation mit 1/

if isnumeric(b)
    sig=sig*(1/b);
    return
end

disp('signal::mrdivide: not implemented yet');