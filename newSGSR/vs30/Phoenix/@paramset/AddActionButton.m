function S = AddActionButton(S, name, string, uipos, callback, tooltip, varargin);
% paramset/AddActionButton - add action button to the OUI of a parameter set
%   S = AddActionButton(S, 'foo', Str, [X,Y, W, H], CLB, Tooltip) defines a
%   button named 'foo' with string Str and position [X,Y, W, H] 
%   in points re the most recently defined querygroup. 
%   CLB is the button's callback; it defaults to paramOUIcallback.
%
%   See also Paramset, Paramset/InitQueryGroup, paramOUI.


if  nargout<1, 
   error('No output argument using AddActionButton. Syntax is: ''S = AddActionButton(S, name, Pos, CallBack)''.');
end
if nargin<5, callback = 'paramOUIcallback;'; end
if nargin<6, tooltip = ''; end
if nargin<7, varargin = {[]}; end

if ~ isequal([1,4], size(uipos))  | ~isnumeric(uipos) | ~isreal(uipos), 
   error('Action button position must be 1x4 real: [X,Y,W,H] in points.'); 
end

% collect all action properties in struct A
style = 'pushbutton';
% put trailing property/value pairs in struct
props = struct(varargin{:});
A = CollectInStruct(style, string, uipos, callback, tooltip, props);

% add to paramset
S = addOUIitem(S, name, 'actionbutton', A);


