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

function str=loadtextfile(name)
% usage: str=loadtextfile(pfad,name)
% loads the pfad,name in a structure of strings. one per line

id=fopen(name,'rt');
%titel=fgetl(id);    % in der ersten Zeile stehen die Namen der PArameter drin
if id<=0
    disp('File not found');
end

ret=sprintf('\n');
str=[];
i=1;
while ~feof(id)
    zeile=fgetl(id);
    str{i}=zeile;
    i=i+1;
end
fclose(id);
