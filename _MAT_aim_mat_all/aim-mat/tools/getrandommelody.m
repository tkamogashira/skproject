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


function fres=getrandommelody(nr,from,to)

if nargin < 3
    to=1000;
end
if nargin < 2
    from=100;
end
if nargin < 1
    nr=5;
end


notearray1=note2fre(1:83);
notearray2=find(notearray1 > from & notearray1 < to);
notearray=notearray1(notearray2);

fres=[];
for i=1:nr
    randnr=ceil(rand(1)*size(notearray,2));
    note=notearray(randnr);
    fres(i)=note;
end
    