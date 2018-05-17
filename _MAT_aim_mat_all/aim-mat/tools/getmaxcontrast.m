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

function contrast=getmaxcontrast(wo,maxpos,minpos,maxs,mins)
% usage: getmaxcontrast(wo,maxs,mins)
% returns the contrast of the maximum at wo
% this is calculated by taking the left and the right minimum of the max

[leftminwo,leftmin]=getminimumleftof(wo,maxpos,minpos,maxs,mins);
if isempty(leftminwo)
    % wenns keinen linkes minimum gibt, versuche, obs ein rechtes gibt
    [rightminwo,rightmin]=getminimumrightof(wo,maxpos,minpos,maxs,mins);
    if ~isempty(rightminwo)
        leftmin=rightmin;
    else
        leftmin=0;
    end
end

[rightminwo,rightmin]=getminimumrightof(wo,maxpos,minpos,maxs,mins);
if isempty(rightminwo)
    rightmin=leftmin;
end

maxval=maxs(find(maxpos==wo));

% Wenn der Punkt kein Maximum der Einhüllenden ist
if isempty(maxval)
    p=0;
%     error('getmaxcontrast:maximum not in list');
end

minval=(rightmin+leftmin)/2;

contrast=(maxval-minval)/(maxval+minval);

