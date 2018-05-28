function resizeEdit(n, newWidth)
% rsEd(n, newWidth)

if ischar(n), n = str2num(n); end;
if ischar(newWidth), newWidth = str2num(newWidth); end;

global GG;
hasUnit = 0;

eh = GG(n)
Edit = get(eh);

oldpos = get(eh, 'position');
if gghasUnit(n), 
   Shift = newWidth-oldpos(3);
   ggmove(n-1, Shift);
end;

ggpos(n, [0 0 newWidth 0]);

figure(gcf); % show

















