function uitoggle(n,varargin);
% uitoggle - make existing button a toggle
%    usage: uitoggle(n, 'text1', 'text2', ...);

h = nan;
if ishandle(n),
   if isequal(lower(get(n,'type')),'uicontrol'),
      h = n;
   end
end
if isnan(h),
   global GG
   if ~isequal(get(GG(n),'style'),'pushbutton'),
      error('not a button');
   end
   h = GG(n);
end


toggles = varargin;
tstr = '({';
for ii=1:length(toggles),
   tstr = [tstr '''' toggles{ii} '''' ' '] ;
end
tstr = [tstr '});'];

set(h,'callback',['MenuButtonToggle' tstr]);
set(h,'string', toggles{1});
set(h,'userdata', 1);

