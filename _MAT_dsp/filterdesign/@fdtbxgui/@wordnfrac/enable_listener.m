function enable_listener(this, eventData)
%ENABLE_LISTENER   Listener to 'enable'.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = get(this, 'Handles');

if strcmpi(this.AutoScale, 'on')
    enab = 'Off';
else
    enab = this.Enable;
end

setenableprop([h.wordlength h.wordlength_lbl], this.Enable);
setenableprop([h.fraclength h.fraclength_lbl], enab);

% [EOF]
