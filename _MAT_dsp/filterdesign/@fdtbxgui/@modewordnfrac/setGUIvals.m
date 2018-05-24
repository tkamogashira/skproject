function setGUIvals(this, Hd, prop)
%SETGUIVALS   PreSet function for the 'GUIvals' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

info = qtoolinfo(Hd);

if isfield(info, prop)
    info = info.(prop);
else
    info.syncops = {prop};
end

set(this, 'Mode', map(Hd, prop));

switch lower(Hd.([prop 'mode']))
    case {'keepmsb', 'keeplsb'}
        set(this, 'WordLength', sprintf('%d', get(Hd, [prop 'WordLength'])));
    case 'specifyprecision'
        set(this, 'WordLength', sprintf('%d', get(Hd, [prop 'WordLength'])));
        for indx = 1:length(info.syncops)
            fl{indx} = sprintf('%d', get(Hd, [info.syncops{indx} 'FracLength']));
        end
        set(this, 'FracLengths', fl);
    otherwise
        % NO OP
end

% -------------------------------------------------------------------------
function mode = map(Hd, prop)

switch lower(Hd.([prop 'mode']))
    case 'keeplsb'
        mode = 'keep lsb';
    case 'keepmsb'
        mode = 'keep msb';
    case 'fullprecision'
        mode = 'full precision';
    case 'specifyprecision'
        mode = 'specify all';
end

% [EOF]
