function syncGUIvals(this, Hd, prop, s)
%SYNCGUIVALS   Sync the values from the GUI to the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

if nargin < 4,
    s = getsettings(this);
end

mode        = s.mode;
wordlength  = s.wordlength;
fraclengths = s.fraclengths;

info = qtoolinfo(Hd);
if isfield(info, prop)
    info = info.(prop);
else
    info.syncops = {prop};
end

% Else sync the mode.
set(Hd, [prop 'Mode'], mode);
switch lower(mode)
    case {'keepmsb', 'keeplsb'}
        set(Hd, [prop 'WordLength'], wordlength);
    case 'specifyprecision'
        set(Hd, [prop 'WordLength'], wordlength);
        for indx = 1:length(info.syncops)
            set(Hd, [info.syncops{indx} 'FracLength'], fraclengths{indx});
        end
    otherwise
        % NO OP.  Nothing else to set.
end

% [EOF]
