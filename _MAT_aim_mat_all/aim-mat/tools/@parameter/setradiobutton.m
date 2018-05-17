% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function param=setradiobutton(param,text,inbox)


cont=param.entries;
nrent=length(cont);


for i=1:nrent
    type=cont{i}.type;
    if strcmp(type,'radiobutton') && strcmp(cont{i}.panel,inbox)
        if strcmp(cont{i}.text,text)
            cont{i}.value=1;
            param.entries=cont;
            return
        end
    end
end

% if still here, then it could have been an 'other' enty:
for i=1:nrent
    type=cont{i}.type;
    if strcmp(type,'radiobutton') && strcmp(cont{i}.panel,inbox) && strcmp(cont{i}.text,'other...')
        cont{i}.userdata=text;
        cont{i}.value=1;
        param.entries=cont;
        return
    end
end

val='error, the entry does not exist';