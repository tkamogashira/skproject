function hm = ggcmenu(Label, callback, ohandle);
% GGCMENU - add contextmenu item to figure or other object
%  returns handle to menu item

if nargin<2, callback = ''; end;

if nargin<3, ohandle = gcf; end;
try,
   figure(get(ohandle,'parent'));
catch,
   figure(gcf);
end

hct = get(ohandle,'UIContextMenu');
if isempty(hct), % create uicontextmenu and attach it to figure
   hct = uicontextmenu;
   set(ohandle,'UIContextMenu', hct);
end

% add labeled menu to contextmenu
hm = uimenu(hct,'label', Label, 'callback', callback);


