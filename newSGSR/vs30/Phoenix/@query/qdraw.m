function h = Qdraw(Q, figh, position);
% query/qdraw - realize a query by creating a uicontrol 
%   QDRAW(Q, figh) creates a group of uicontrols and returns 
%   their graphics handles in a struct. 
%   The uicontrols are created according to the specs in query object Q. 
%   The controls are added to figure with handle figh. The default figh 
%   is gcf, the handle of the current figure.
%
%   QDRAW(Q, figh, [X, Y]) places the uicontrols at coordinates
%   X,Y (expressed in points) on the figure.
%
%   See also Query, Query/setProp.

if nargin<2, figh = gcf; end;
if nargin<3, position = [20 20]; end;

if isempty(Q.Param), return; end % void query object

switch Q.Style,
case '', error('Cannot create uicontrol for void query objects.');
case 'edit', h = localDrawEdit(Q, figh, position);
case 'toggle', h = localDrawToggle(Q, figh, position);
otherwise,
   error(['Drawing of ' Q.Style '-style queries is not yet implemented.']);
end

% impose Props
fns = fieldnames(Q.Props);
for ii=1:length(fns),
   uic = fns{ii};
   handle = getfield(h, uic);
   propvalStruct = getfield(Q.Props,uic);
   set(handle, propvalStruct);
end

%===================================

function h = localDrawEdit(Q, figh, startPos);
h = [];
[prompt, edit, unit] = deal([]);
tagPrefix = Q.Param.name;
figcolor = get(figh, 'color');
% prompt
if ~isempty(Q.Prompt),
   prompt = uicontrol(figh, 'style', 'text', ...
      'tag', [tagPrefix 'Prompt'], ...
      'visible', 'off', ...
      'Units', 'points', ...
      'HorizontalAlignment', 'left', ...
      'backgroundcolor', figcolor, ...
      'foregroundcolor', [0 0 0], ...
      'tooltip', Q.Tooltip, ...
      'string', Q.Prompt);
   startPos = localAdjustPosition(prompt, startPos, [0 -2]);
end
% edit
edit = uicontrol(figh, 'style', 'edit', ...
   'tag', [tagPrefix 'Edit'], ...
   'visible', 'off', ...
   'Units', 'points', ...
   'HorizontalAlignment', 'left', ...
   'backgroundcolor', [1 1 1], ...
   'foregroundcolor', [0 0 0], ...
   'string', [Q.Ustring 'XXX']);
startPos = localAdjustPosition(edit, startPos);
set(edit, 'string', bracket(Q.Param.ValueStr,0)); % remove brackets from valueStr
% unit
U = Q.Param.unit;
if ~isempty(U),
   unit = uicontrol(figh, 'style', 'text', ...
      'tag', [tagPrefix 'Unit'], ...
      'visible', 'off', ...
      'Units', 'points', ...
      'HorizontalAlignment', 'left', ...
      'backgroundcolor', figcolor, ...
      'foregroundcolor', [0 0 0], ...
      'tooltip', localUnitTooltip(U), ...
      'string', U);
   startPos = localAdjustPosition(unit, startPos, [3 -2]);
end
% return handles in struct
h = collectInStruct(prompt, edit, unit);

function h = localDrawToggle(Q, figh, startPos);
h = [];
[prompt, button, unit] = deal([]);
tagPrefix = Q.Param.name;
figcolor = get(figh, 'color');
% parse toggle set
toggleSet = Q.Ustring;
if ischar(toggleSet), % convert to cellstr
   toggleSet = strSubst(Q.Ustring, ' ', '');
   toggleSet = strSubst(toggleSet, '{', '{''');
   toggleSet = strSubst(toggleSet, '}', '''}');
   toggleSet = strSubst(toggleSet, ',', ''',''');
   toggleSet = eval(toggleSet);
end
% width of button is based on largest string in set - get that
for ii=1:length(toggleSet), LL(ii) = length(toggleSet{ii}); end
Width = max(LL); 
% find out what the current value of the toggle is ...
% ... don't crash if none matches - just take first value of set
itoggle = strmatch(Q.Param.ValueStr, toggleSet);
if isempty(itoggle), itoggle=1; end;
% generate small struct that makes the  toggle self-supporting
buttonStatus = CollectInStruct(toggleSet, itoggle);
Fontsize = get(0, 'defaultuicontrolfontsize');
% prompt
if ~isempty(Q.Prompt),
   prompt = uicontrol(figh, 'style', 'text', ...
      'tag', [tagPrefix 'Prompt'], ...
      'visible', 'off', ...
      'Units', 'points', ...
      'HorizontalAlignment', 'left', ...
      'backgroundcolor', figcolor, ...
      'tooltip', Q.Tooltip, ...
      'foregroundcolor', [0 0 0], ...
      'string', Q.Prompt);
   startPos = localAdjustPosition(prompt, startPos, [0 -2]);
end
% button
button = uicontrol(figh, 'style', 'pushbutton', ...
   'tag', [tagPrefix 'Button'], ...
   'visible', 'on', ...
   'Units', 'points', ...
   'position', [startPos Fontsize*Width 15], ...
   'foregroundcolor', [0 0 0], ...
   'userdata', buttonStatus, ...
   'callback', 'toggleCallback;', ...
   'string', [toggleSet{itoggle}]);
startPos = startPos + [1 0]*Width;
% return handles in struct
h = collectInStruct(prompt, button);


function startPos = localAdjustPosition(h, startPos, offset);
if nargin<3, offset=[0,0]; end
pos = get(h, 'position');
extent = get(h, 'extent');
set(h, 'position', [startPos+offset, extent(3) 15], 'visible', 'on');
startPos = startPos + [extent(3) 0];

function tt = localUnitTooltip(U);
switch U,
case 'Hz', tt = 'Heinrich Rudolf Hertz (1857-1894)';
otherwise, tt = ''; 
end











