% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ca(namearg)
% function ca('name'): close all open graphic windows that dont contain 'name' in their title

if nargin==0
    namearg='browser';
%     namearg{2}='aim-mat';
end

if ~iscell(namearg)
    if ~ischar(namearg)
        disp('ca only works with strings as input')
    else
        name{1}=namearg;
    end
% else
%     name=namearg;
end




all_windows=get(0,'children');  % is not identic to:
all_windows=allchild(0);
for i=1:length(all_windows)
    if strcmp(get(all_windows(i),'type'),'figure');
        titl=get(all_windows(i),'name');
        can_be_cleared=1;
        for j=1:length(name)
            if ~isempty(strfind(titl,name{j}))
                can_be_cleared=0;
            end
        end
        if can_be_cleared
%             set(0,'ShowHiddenHandles','on')
            close(all_windows(i));
        end
    end
end
