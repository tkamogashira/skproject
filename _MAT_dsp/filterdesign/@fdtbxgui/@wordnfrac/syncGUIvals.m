function syncGUIvals(this, Hd, prop, s)
%SYNCGUIVALS   Sync the values from the GUI to the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 4,
    s = getsettings(this);
end

wordlength  = s.wordlength;
autoscale   = s.autoscale;
fraclengths = s.fraclengths;

info = qtoolinfo(Hd);

if isfield(info, prop)
    info = info.(prop);
else
    info.syncops = {prop};
end

if this.maxword == 2 && ~isempty(this.WordLabel2),
    set(Hd, [info.syncops{1} 'WordLength'], wordlength);
    set(Hd, [info.syncops{2} 'WordLength'], s.wordlength2);
else
    set(Hd, [prop 'WordLength'], wordlength);
end

switch lower(prop)
    case 'input'
        % NO OP.
    case 'output'
        if strcmpi(this.AUtoScaleAvailable, 'On')
            if strcmpi(autoscale, 'off')
                set(Hd, 'OutputMode', 'SpecifyPrecision');
            else
                set(Hd, 'OutputMode', 'AvoidOverflow');
            end
        end
    otherwise
        if strcmpi(this.AutoScaleAvailable, 'On'),
            set(Hd, [prop 'AutoScale'], strcmpi(autoscale, 'on'));
        end

end

if strcmpi(this.AutoScaleAvailable, 'off') || ...
        (strcmpi(this.AutoScaleAvailable, 'on') && strcmpi(autoscale, 'off')),
    if isempty(info.syncops)
        info.syncops = {prop};
    end
    for indx = 1:min(length(info.syncops), length(fraclengths))
        set(Hd, [info.syncops{indx} 'FracLength'],  fraclengths{indx});
    end
end

% [EOF]
