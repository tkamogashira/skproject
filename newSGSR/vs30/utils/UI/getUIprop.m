function val = getUIprop(figh, tag, prop);
% getUIprop - get properties stored in userdata UIcontrols of a figure
%   getUIprop(h, 'tag') looks for a uicontrol on figure h with tag 'tag'
%   and returns all its properties  in a struct. If h is not specified, 
%   the current figure is queried.
%
%   getUIhandle(h, 'tag', 'prop') only the value of property 'prop'.
%
%   getUIhandle(h, 'tag.field') returns the field of the userdata
%   of the uicontrol tagged 'tag'. The userdata must be a struct and
%   contain the given field.
%
%   getUIhandle(h, 'tag.field.subfield') can be used to access fields of
%   fields, etc.
% 
%   See also GET, setUIprop, hasUIprop.

figh; tag;
if nargin<3, prop=''; end;
if isempty(figh), error('No figure to query.'); return; end;

[tag fields] = strtok(tag, '.');
uh = getUIhandle(figh, tag);
if isempty(fields),
   if isempty(prop), val = get(uh);
   else, val = get(uh, prop); end;
else, % userdata implied
   val = get(uh, 'userdata');
   if ~isequal('.*', fields), % specific (sub^n)fields wanted
      val = eval(['val' fields]);
   end
end
