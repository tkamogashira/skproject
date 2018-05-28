function uitoggle(n,varargin);

global GG
if ~isequal(get(GG(n),'style'),'pushbutton'),
   error('not a button');
end

toggles = varargin;
tstr = '({';
for ii=1:length(toggles),
   tstr = [tstr '''' toggles{ii} '''' ' '] ;
end
tstr = [tstr '});'];

set(GG(n),'callback',['MenuButtonToggle' tstr]);
set(GG(n),'string', toggles{1});
set(GG(n),'userdata', 1);

