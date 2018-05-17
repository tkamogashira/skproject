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


function width=getmaxwidth(wo,maxpos,minpos,maxs,mins)
% usage: width=getmaxwidth(wo,frewomax,fremaxs,frewomin,fremins)
% returns the width of the maximum
% this is calculated by taking the left and the right minimum of the max

[leftminwo,val]=getminimumleftof(wo,maxpos,minpos,maxs,mins);
if isempty(leftminwo)
    % wenns keinen linkes minimum gibt, versuche, obs ein rechtes gibt
    [rightminwo,rightmin]=getminimumrightof(wo,maxpos,minpos,maxs,mins);
    if ~isempty(rightminwo)
        leftminwo=rightminwo;
    else
        leftminwo=0;
    end
end

[rightminwo,val]=getminimumrightof(wo,maxpos,minpos,maxs,mins);
if isempty(rightminwo)
    rightminwo=leftminwo;
end

width=abs((leftminwo+rightminwo)/2);

