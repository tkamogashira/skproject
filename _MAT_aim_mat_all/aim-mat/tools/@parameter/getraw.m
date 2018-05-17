% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function val=getraw(param,text,inbox)
% returns the current value of the parameter as it is, no transformation

cont=param.entries;
nrent=length(cont);

if nargin <2 % in case we want the whole stucture
    val=cont;
    return
end

if nargin<3 % search in all subsections
    inbox='all';
end


nr=getentrynumberbytext(param,text,inbox);

if nr>0
    type=cont{nr}.type;
    if strcmp(type,'float')
        val=cont{nr}.rawvalue;
        return
    else
        val=cont{nr}.value;
        return
    end
else
    error('error, the entry does not exist');
    %     val=0;  % we must return a logical value otherwise it can generate difficult errors
end