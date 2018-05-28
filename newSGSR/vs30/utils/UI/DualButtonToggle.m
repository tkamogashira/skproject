function y=DualButtonToggle;
% toggles pair of buttons both of which are initialized by NewUItoggle

h= gcbo;
if ~isequal('pushbutton',get(h, 'style')),
   error('callback object must be pushbutton');
end;
ud = get(h,'userdata');

ha = findobj(gcbf, 'tag', ud.Ant);
if ~isequal(1,length(ha)) | ~ishandle(ha),
   error('Cannot find antagonist button');
end

local_setButton(ha, ud.i);
local_setButton(h, 3-ud.i);

drawnow;

% ----------locals
function local_setButton(h,ii);
ud = get(h,'userdata');
setstring(h,ud.ButString{ii});
ud.i = ii;
set(h,'userdata', ud);
