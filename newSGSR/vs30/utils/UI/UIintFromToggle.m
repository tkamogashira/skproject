function [y, strval] = UIintFromToggle(h);
% UIintFromToggle - returns userdata of pushbutton, sets foreground color to black and matches strings
if ischar(h), h = UIhandle([h 'Button']); end;
st = get(h,'Style');
if ~isequal(st,'pushbutton'),
   error('UIintFromToggle only valid for pushbuttons.');
end
menubuttonmatch(h);
y = get(h,'userdata');
if isstruct(y),
   y = y.i;
end
set(h,'foregroundcolor',[0 0 0]);
strval = get(h, 'string');
