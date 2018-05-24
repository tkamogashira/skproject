function updateautoscale(this, Hd, prop)
%UPDATEAUTOSCALE   Update the autoscaled properties.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

info = qtoolinfo(Hd);

if isfield(info, prop)
    info = info.(prop);
    if isempty(info.syncops)
        info.syncops = {prop};
    end
else
    info.syncops = {prop};
end

if strcmpi(this.autoscale, 'on')
    for indx = 1:length(info.syncops)
        fl{indx} = sprintf('%d', get(Hd, [info.syncops{indx} 'FracLength']));
    end
    set(this, 'FracLengths', fl);
end

% [EOF]
