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


function str=getargument(source,search)
% usage: str=getargument(source,search)
% searchs in the pairs of parameters 'param','value' for the argument and returns the value as string
% source must be a even number of input parameters

% for compatibility with old version
if ~isfield(source,'name')
    nr=size(source,2);  % so many pairs
    for i=1:nr
        param=source(i);
        if strcmp(param,search)
            str= source(i+1);
            return
        end
    end
    str{1}='';
    return
   
else
    
    % new version is much more elegant
    nr=size(source.name,2);  % so many pairs
    for i=1:nr
        param=source.name{i};
        if strcmp(param,search)
            str=source.argument{i};
            
            % if the argument is put into "[]" then remove them
            return
        end
    end
end
str='';
return 


