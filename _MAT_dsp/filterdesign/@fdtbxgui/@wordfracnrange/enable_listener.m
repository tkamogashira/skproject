function enable_listener(this, eventData)
%ENABLE_LISTENER   Listener to the 'enable' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

siggui_enable_listener(this);

hs = getcomponent(this, '-class', 'siggui.selectorwvalues');
if (strcmpi(this.AutoScale, 'Off') || ...
        strcmpi(this.AutoScaleAvailable, 'Off')) && ...
        strcmpi(this.EnableFracLengths, 'On')
    enab = this.Enable;
else
    enab = 'Off';
end
set(hs(1:this.Maximum), 'Enable', enab);

% [EOF]
