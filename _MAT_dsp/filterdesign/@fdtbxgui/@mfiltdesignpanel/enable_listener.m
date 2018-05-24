function enable_listener(this, eventData)
%ENABLE_LISTENER   Listener to 'enable' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(this.Enable, 'Off')
    sigcontainer_enable_listener(this);
else
    set(allchild(this), 'Enable', 'On');

    h = get(this, 'Handles');

    setenableprop([h.type h.type_lbl h.interpolationfactor_lbl ...
        h.decimationfactor_lbl], 'On');

    if this.isDesigned
        setenableprop(h.design, 'Off');
    else
        setenableprop(h.design, 'On');
    end
end

% [EOF]
