function [MSname, handles] = MenuStatusName(MenuName);

% first try if generic StimMenuStatus matches the MenuName
global StimMenuStatus
isstimmenu = 0;
if ~isempty(StimMenuStatus),
   isstimmenu = isequal(StimMenuStatus.MenuName, MenuName);
end
if isstimmenu,
   MSname = 'StimMenuStatus';
else, % menu named XXXMenu has private global XXXMenuStatus
   MSname = [MenuName 'MenuStatus'];
end
if nargout>1, % handles might not be present yet, so only get them when asked
   eval(['global ' MSname]);
   eval(['handles = ' MSname '.handles;']);
end


