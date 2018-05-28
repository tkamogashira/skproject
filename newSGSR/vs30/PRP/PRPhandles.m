function prph = PRPhandles;
% PRPhandles - returns handles of PRP-related UIcontrols in struct
%   returns [] if no menu is active
if ~StimMenuActive,
   prph = [];
   return;
end

persistent PrevHandles

% check if things haven't changed since last call
if ~isempty(PrevHandles),
   if isequal(messagehandle, PrevHandles.hmess),
      hh = PrevHandles;
      return;
   end
end

sh = StimMenuHandles;
tags = fieldnames(sh);
sdef = {};
for ii=1:length(tags),
   hh = getfield(sh, tags{ii});
   switch get(hh, 'type')
   case 'uicontrol', % only buttons and edits
      style = get(hh, 'style');
      Accept = isequal(style,'pushbutton') | isequal(style, 'edit');
   case 'uimenu', % only menus, no menu items
      Accept = isequal(get(hh, 'parent'), sh.Root);
   otherwise,
      Accept = 0;
   end
   if Accept,
      sdef = {sdef{:} tags{ii} hh};
   end
end

if isempty(sdef),
   prph = [];
else,
   prph = struct(sdef{:});
end





