% tool
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


function int=randint(von,bis)
% produces an int between von and bis or from 1 to von

if nargin < 2
    bis=von;
    von=1;
end

v=rand(1)*(bis-von);
v=v+von;
int=round(v);
