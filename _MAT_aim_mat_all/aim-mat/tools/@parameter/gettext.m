% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function name=gettext(param,i,inbox)
% return the description text of the parameter with the entry number i.
% if i is a string then return the full string of the probably abbreviated

if nargin==1
    name=param.name;
    return
end

if isnumeric(i)
    name=param.entries{i}.text;
elseif ischar(i)
    if nargin==2 % search in all subsections
        inbox='all';
    end
    nr=getentrynumberbytext(param,i,inbox);
    name=param.entries{nr}.text;
end
