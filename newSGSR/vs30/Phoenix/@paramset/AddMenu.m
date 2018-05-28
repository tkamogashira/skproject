function S = AddMenu(S, name, label, callback, varargin);
% paramset/AddMenu - add pulldown menu to the OUI of a parameter set
%   S = AddMenu(S, 'foo', L, CLB, ...) defines a UImenu named 
%   'foo' with label L and adds it to the OUI definitions of S.
%   CLB is the menu's callback; it defaults to ''.
%   CLB may be followed by prOperty/value pairs to be passed to
%   MatLab's uimenu when the OUI is realized.
%
%   Menu items can be added to the menu using paramset/AddMenuItem.
%
%   See also Paramset, Paramset/InitQueryGroup, paramOUI.


if  nargout<1, 
   error('No output argument using AddMenu. Syntax is: ''S = AddMenu(S, name, Pos, CallBack)''.');
end
if nargin<4, callback = ''; end
if nargin<5, varargin = {[]}; end

% collect all action properties in struct A
style = 'pulldownmenu';
% put trailing property/value pairs in struct
props = struct(varargin{:});
uipos = nan; % for compatibilty with other OUI items (see paramOUI )
M = CollectInStruct(style, label, uipos, callback, props);

% add to paramset
S = addOUIitem(S, name, 'menu', M);


