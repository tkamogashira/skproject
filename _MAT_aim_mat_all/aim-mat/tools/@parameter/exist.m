% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function val=exist(param,text,inbox)
% returns a boolean value that indicates if that string has a valid field

cont=param.entries;
nrent=length(cont);

if nargin<3 % search in all subsections
    inbox='all';
end


nr=getentrynumberbytext(param,text,inbox);

if nr>0
    val=1;
else
    val=0;  % we must return a logical value otherwise it can generate difficult errors
end