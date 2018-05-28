function hh = getUIhandles(figh);
% getUIhandles - get handles of all UIcontrols of a figure in a struct

if nargin<1, figh=gcf; end;
Iam = findobj(figh, 'tag', 'Iam');
if ishandle(Iam), 
   hh = get(Iam, 'userdata');
   hh = hh.handles;
else,
   
end


