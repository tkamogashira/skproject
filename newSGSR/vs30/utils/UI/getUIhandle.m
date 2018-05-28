function hh = getUIhandle(figh, tag, prop);
% getUIhandle - get handle(s) of a UIcontrols of a figure in a struct
%   getUIhandle(h) returns handles of uicontrols/menus in struct var.
%   If h is not specified, the current figure is queried.
%
%   getUIhandle(h, Tag) returns the handle having the string Tag as tag value
%
%   getUIhandle(h, Tag, Prop) returns the value of the Prop property of 
%   uicontrol getUIhandle(h, Tag);
% 
%   See also setUIprop

if nargin<2, tag=''; end;
if nargin<3, prop=''; end;

if nargin<1, figh=get(0,'CurrentFigure'); end; % avoid generating new figure (gcf)
if isempty(figh), hh=[]; return; end;
Iam = findobj(figh, 'tag', 'Iam');
if ishandle(Iam), 
   hh = get(Iam, 'userdata');
   hh = hh.handles;
else,
   hh = CollectMenuHandles('',figh);
end
if ~isempty(tag), hh = eval(['hh.' tag]); end
if ~isempty(prop), hh = get(hh, prop); end

