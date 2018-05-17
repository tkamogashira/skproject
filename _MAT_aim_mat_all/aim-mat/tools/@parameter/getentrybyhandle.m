% method of class @parameter
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function entry=getentrybyhandle(param,hand)


cont=param.entries;
nrent=length(cont);

% first search for the exact fit
for i=1:nrent
    if isfield(cont{i},'handle')
        for j=1:length(cont{i}.handle)
            if cont{i}.handle{j}==hand
                entry=cont{i};
                return
            end
        end
    end
end

entry=[];