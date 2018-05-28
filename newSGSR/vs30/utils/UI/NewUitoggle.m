function NewUItoggle(n,antagonist, varargin);

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

N = length(varargin);
ud.N = N;
ud.ButString = varargin;
ud.Ant = antagonist;
ud.i = 1;
set(h,'userdata',ud);
set(h,'string', varargin{1});
set(h,'callback', 'DualButtonToggle;');


