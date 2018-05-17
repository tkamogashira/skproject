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


function ret=extracttolist(list,delimiter)
%usage: ret=extracttolist(list,delimiter)
% returns a list of strings that are in 'list' and deliminited by delimiter

nrwhere=findstr(list,delimiter); % 9 is tab!
start=1;
for i=1:length(nrwhere)
    stop=nrwhere(i)-1;
    ret{i}=list(start:stop);
    start=nrwhere(i);
end 

% and the last one before the end of the line
ret{i+1}=list(start:end);
