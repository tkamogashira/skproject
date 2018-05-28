function EveryHandleAndAll = allObjectsInFigure(h, hflag)
% allObjectInFigure - return all handles of objects within figure
%   allObjectInFigure(h) returns all handles of objects in figure
%   whether hidden or not. Input arg h defaults to gcf.
%   allObjectInFigure(h, 'nohidden') suppresses hidden handles.

if nargin<1, h = gcf; end;
if nargin<2, hflag = ''; end;

hflag = lower(hflag);

if isequal(hflag, 'nohidden'), qqq = 'off';
else, qqq= 'on';
end

% compile a simple list of *all* handles, hidden or not, and store in IAm
shh = get(0,'showhiddenhandles');
set(0,'showhiddenhandles', qqq);
EveryHandleAndAll = findobj(h);
set(0,'showhiddenhandles', shh);
