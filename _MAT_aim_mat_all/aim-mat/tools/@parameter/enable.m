% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function param=enable(param,text,disablevalue,inbox)
% if it has a grafical representation then disable

cont=param.entries;
nrent=length(cont);

if nargin<4 % search in all subsections
    inbox='all';
end

nr=getentrynumberbytext(param,text,inbox);
if nr>0
    param.entries{nr}.enable=disablevalue;  % save the value
    if isfield(cont{nr},'handle') && ishandle(cont{nr}.handle{1}) % and set in the gui as well
        hands=cont{nr}.handle;
        for i=1:length(hands)
            switch disablevalue
                case 1
                    set(hands{i},'enable','on');
                case 0
                    set(hands{i},'enable','off');
            end
        end
    end
else
    error('setvalue::error, the entry does not exist');
end
