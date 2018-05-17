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


function fres=getupdownmelody(nr,aroundfre,upordown)

if nargin < 3
    upordown='down';
end
if nargin < 2
    aroundfre='A4';
end
if nargin < 1
    nr=5;
end


% notearray1=note2fre(1:83);
% notearray2=find(notearray1 > aroundfre & notearray1 < to);
% notearray=notearray1(notearray2);

fres=[];
df=power(2,1/12);
if strfind(upordown,'up')
    fre1=note2fre(aroundfre);
    fre2=fre1*power(df,2);
else
    fre1=note2fre(aroundfre);
    fre2=fre1/power(df,2);
end

for i=1:nr
    if mod(i,2)
        fres(i)=fre1;
    else
        fres(i)=fre2;
    end
end
    