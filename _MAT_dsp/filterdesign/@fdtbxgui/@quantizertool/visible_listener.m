function visible_listener(this, eventData)
%   Copyright 1999-2002 The MathWorks, Inc.

siggui_visible_listener(this, eventData);

if strcmpi(this.Visible,'on') &  strcmpi(this.Enable,'on')
  mode_listener(this,eventData);
end