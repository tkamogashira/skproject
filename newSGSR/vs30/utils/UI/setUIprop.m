function setUIprop(figh, tag, prop, val);
% setUIprop - set properties of UIcontrols in a figure
%   setUIprop(h, 'tag', 'prop', val) looks for a uicontrol in figure h
%   having tag 'tag' and sets its property 'prop' to value val.
%
%   The shorter format setUIprop(h, 'tag', val) sets the 'userdata' of the
%   uicontrol, .e., it is equivalent to setUIprop(h,'tag', 'userdata', val)
%
%   The format setUIprop(h, 'tag.field', val) sets the field of the userdata 
%   struct of the uicontrol to val. This equivalent to
%   setUIprop(h,'tag', 'userdata', setfield(uval)), where uval is the previous
%   value of the userdata property.
%
%   Fields of fields can be set by setUIprop(h, 'tag.field.subfield', val), etc.
%
%   See also getUIhandle

if nargin==4, % long format
   uih = getUIhandle(figh, tag);
   set(uih, prop, val);
   return;
end
% nargin==3 so we need some parsing
val = prop; % shifted arg list
[tag fields] = strtok(tag,'.');
uih = getUIhandle(figh, tag);
if isempty(fields), % userdata implied; no field stuff
   set(uih, 'userdata', val);
else, % get old value of userdata
   ud = get(uih, 'userdata');
   eval(['ud' fields ' = val;']); % replace given field
   set(uih, 'userdata', ud); % replace with new struct value
end


