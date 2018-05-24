function setGUIvals(this, Hd, prop)
%SETGUIVALS   PreSet function for the 'GUIvals' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

info = qtoolinfo(Hd);

if isfield(info, prop)
    info = info.(prop);
    if isempty(info.syncops)
        info.syncops = {prop};
    end
else
    
    % OUTPUT/INPUT case.
    info.syncops = {prop};
end


if this.maxword == 2 && ~isempty(this.WordLabel2)
    set(this, ...
        'WordLength', sprintf('%d', get(Hd, [info.syncops{1} 'WordLength'])), ...
        'WordLength2', sprintf('%d', get(Hd, [info.syncops{2} 'WordLength'])));
else
    set(this, 'WordLength', sprintf('%d', get(Hd, [prop 'WordLength'])));
end

switch prop
    case 'input'
        % NO OP
    case 'output'
        if strcmpi(this.AutoScaleAvailable, 'On')
            if strcmpi(Hd.OutputMode, 'SpecifyPrecision')
                set(this, 'AutoScale', 'Off');
            else
                set(this, 'AutoScale', 'On');
            end
        end
    otherwise
        if strcmpi(this.AutoScaleAvailable, 'On'),
            if get(Hd, [prop 'AutoScale'])
                autoscale = 'on';
            else
                autoscale = 'off';
            end
            set(this, 'AutoScale', autoscale);
        end
end
% if strcmpi(this.AutoScale, 'Off'),
    for indx = 1:length(info.syncops)
        fl{indx} = sprintf('%d', get(Hd, [info.syncops{indx} 'FracLength']));
    end
    set(this, 'FracLengths', fl);
% end


% [EOF]
