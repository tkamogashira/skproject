% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function ret=release(type)

switch lower(type)
    case 'ver'
        ret='AIM-MAT v1.5';
    case 'date'
        ret=date;
    otherwise 
        ret='';
end
