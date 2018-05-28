function nf()
% nf - show next figure
%   nf brings the next figure to the fore.
%
%   See also ff.

persistent LastVisited

if isempty(LastVisited),
    LastVisited = get(0,'currentfigure');
end
if isempty(LastVisited),
    LastVisited = 0;
end

AllHandles = sort(findobj(0,'type','figure'));
if isempty(AllHandles),
    return;
end

h = min(AllHandles(AllHandles>LastVisited));
if isempty(h),
    h = AllHandles(1);
end

figure(h);
LastVisited = h; 