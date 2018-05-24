function updateautoscale(this, Hd, prop)
%UPDATEAUTOSCALE   Update the autoscaled property.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

info = qtoolinfo(Hd);

if isfield(info, prop)
    info = info.(prop);
    if isempty(info.syncops)
        info.syncops = {prop};
    end
else
    info.syncops = {prop};
end

fl = get(this, 'FracLengths');

switch lower(get(Hd, [prop 'mode']))
    case {'keepmsb', 'keeplsb'}
        for indx = 1:length(info.syncops)
            fl{indx} = sprintf('%d', get(Hd, [info.syncops{indx} 'FracLength']));
        end
        set(this, 'FracLengths', fl);
    case 'specifyprecision'
        % NO OP.
    case 'fullprecision'
        set(this, 'WordLength', sprintf('%d', get(Hd, [prop 'WordLength'])));
        for indx = 1:length(info.syncops)
            fl{indx} = sprintf('%d', get(Hd, [info.syncops{indx} 'FracLength']));
        end
        set(this, 'FracLengths', fl);
end


% [EOF]
