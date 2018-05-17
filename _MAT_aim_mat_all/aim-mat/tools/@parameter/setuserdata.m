% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function param=setuserdata(param,data,text,inbox)
% the whole struct can have an user entry and every part of the structure
% as well. These can be used by the user for example for the 'other...'
% radiobutton

if nargin <3
    param.userdata=data;
else
    cont=param.entries;
    nrent=length(cont);
    for i=1:nrent
        if strcmp(cont{i}.text,text)&& strcmp(cont{i}.panel,inbox)
            cont{i}.userdata=data;
            param.entries=cont;
            return
        end
    end
end



