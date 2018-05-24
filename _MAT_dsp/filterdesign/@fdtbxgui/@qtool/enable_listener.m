function enable_listener(this, varargin)
%ENABLE_LISTENER   Listener to 'enable'.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = get(this, 'Handles');

% enab = get(this, 'Enable');
% if strcmpi(enab, 'Off')
sigcontainer_enable_listener(this, varargin{:});
% else
%     enab = 'off';
%     setenableprop([h.signed h.inputwordlength_lbl h.inputwordlength h.castbeforesum ...
%         h.roundmode_lbl h.roundmode h.overflowmode_lbl h.overflowmode], enab);
%
%     set(allchild(this), 'Enable', enab);
% end

if issupported(this)
    info = qtoolinfo(this.Filter);
    enab = this.Enable;
else
    enab = 'off';
    info = [];
end
setenableprop([h.arithmetic_lbl h.arithmetic], enab);

updatecastbeforesum(this);
updatemodes(this);

% [EOF]
