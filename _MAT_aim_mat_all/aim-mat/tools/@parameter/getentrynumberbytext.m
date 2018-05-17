% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function nr=getentrynumberbytext(param,text,inbox)

nr=-1;



if nargin<3 % search in all subsections
    inbox='all';
end

cont=param.entries;
nrent=length(cont);


% text can be a string or a number
if isstr(text) % if its a sting then look for the member number
    % first search for the exact fit
    for i=1:nrent
        if strcmp(cont{i}.text,text) && (strcmp(cont{i}.panel,inbox) || strcmp(inbox,'all'))
            nr=i;
            return
        end
    end
    
    
    % then search for the abbreviation
    for i=1:nrent
        if ~isempty(strfind(cont{i}.text,text)) && (strcmp(cont{i}.panel,inbox) || strcmp(inbox,'all'))
            nr=i;
            return
        end
    end
else
    nr=text; % in this case we wanted to access it by the number
end

