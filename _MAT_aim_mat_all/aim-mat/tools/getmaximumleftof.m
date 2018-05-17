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


function [pos_max,maxval]=getmaximumleftof(where,maxpos,minpos,maxs,mins)
% usage: [pos_max,maxval]=getmaximumleftof(where,womins,minvals,womaxs,maxvals)
% returns the maximum that is left of point "where"
% mins and maxs must be complete sets of minimums and maximums 
% interwoven

pos_max=[];
maxval=[];

if isempty(maxpos)
    return;
end

if where < maxpos(1)
    return;
    error('getminimumleftof:: no maximum left of point');
end


nr =length(where);
for j=1:nr
    cwhere=fround(where(j),5);
    nr_maxs=length(maxpos);
    for i=nr_maxs:-1:1
        if fround(maxpos(i),5) < cwhere
            pos_max(j)=maxpos(i);
            maxval(j)=maxs(i);
            break;
        end
    end
end
% 
% nr_maxs=length(womaxs);
% for i=nr_maxs:-1:1
%     if womaxs(i) < where
%         pos_max=womaxs(i);
%         maxval=maxvals(i);
%         return;
%     end
% end
% 
