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


function [pos_min,minval,index]=getminimumrightof(where,maxpos,minpos,maxs,mins)
% returns the minimum that is right of point "where"
% mins and maxs must be complete sets of minimums and maximums 
% interwoven


pos_min=[];
minval=[];
index=-1;

if isempty(maxpos)
    return;
end
if where > minpos(end)
    return;
    error('getminimumrightof:: no minimum right of point');
end

nr =length(where);
for j=1:nr
    cwhere=where(j);
    nr_mins=length(minpos);
    for i=1:nr_mins
        if fround(minpos(i),5) > fround(cwhere,5)
            pos_min(j)=minpos(i);
            minval(j)=mins(i);
            index(j)=i;
            break;
        end
    end
end
