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


function generateparameterfile(makefilename,varargin)
% usage:generateparameterfile(makefilename,varargin)
% produces the "makefilename" from the parameters in varargin


nr_pairs=size(varargin{1},2)/2;

if mod(size(varargin{1},2),2)==1
    disp('odd number of parameters - please input a full set of parameters and arguments');
    return;
end

count=1;
for i=1:nr_pairs
    a=varargin{1}{count};
    b=varargin{1}{count+1};
    if isnumeric(b)
        te='[';
        for j=1:size(b,2)
            sss=sprintf('%f',b(j));
            te=[te sss ' '];
        end
        te=[te ']'];
        str{i}=sprintf('%s\t%s',varargin{1}{count},te);
    else
        if iscell(b)
            te='[';
            for j=1:size(b,2)
                te=[te b{j} ' '];
            end
            te=[te ']'];
            str{i}=sprintf('%s\t%s',varargin{1}{count},te);
        else
            str{i}=sprintf('%s\t%s',a,b);
        end
    end
    count=count+2;
end


savetofile(str,makefilename);