% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function wheter=is_current_var(varname,in)
% usage: is_current_var(varname,)
% returns a bool whether this variable is a defined variable or not

n=size(in,1);
for i=1:n
    if strcmp(in(i),varname)
        wheter=1;
        return
    end
end
wheter=0;

