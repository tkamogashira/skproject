function S = AddMenuItem(S, name, parent, label, acc, callback, varargin);
% paramset/AddMenuItem - add item to pulldown men of paramset OUI
%   S = AddMenuItem(S, 'foo', P, L, Acc, CLB, ...) defines a 
%   UImenuitem named 'foo' with parent P, label L, and accelerator
%   Acc, and adds it to the OUI definitions of S. Parent P is the 
%   name of a menu or menu item defined for the same OUI.
%   CLB is the menu's callback; it defaults to ''.
%   CLB may be followed by property/value pairs to be passed to
%   MatLab's uimenu when the OUI is realized.
%   A label starting with an underscore: '_mylabel' results
%   in a separator added to the menu item; the underscore is
%   removed from the label.
%
%   Pulldown menus can be added to a OUI using paramset/AddMenu.
%
%   See also Paramset, Paramset/InitQueryGroup, paramOUI.


if  nargout<1, 
   error('No output argument using AddMenuItem. Syntax is: ''S = AddMenuItem(S, name, parent, label, CallBack)''.');
end
if nargin<5, acc = {''}; end
if nargin<6, callback = 'paramOUIcallback;'; end
if nargin<7, varargin = {[]}; end

if ~ischar(parent),
   error('Parent argument must be string.');
end
% collect all action properties in struct A
style = 'menuitem';
% put trailing property/value pairs in struct
props = struct(varargin{:});
uipos = nan; % for compatibilty with other OUI items (see paramOUI )
M = CollectInStruct(style, parent, label, acc, uipos, callback, props);

% add to paramset
S = addOUIitem(S, name, 'menuitem', M);


