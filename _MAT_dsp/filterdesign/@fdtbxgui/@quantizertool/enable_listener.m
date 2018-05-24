function enable_listener(this, eventData)

%   Copyright 1999-2002 The MathWorks, Inc.

siggui_enable_listener(this, eventData);

if strcmpi(this.Enable,'on')
  % Trigger the mode_listener to repaint the enabled/disabled states whenever
  % this becomes enabled.
  mode_listener(this,eventData);
end