function filter = setfilter(this, filter)
%SETFILTER   PreSet function for the 'filter' property.

%   Copyright 1999-2011 The MathWorks, Inc.

% Make sure that the filter can be quantized

this.privFilter = filter;

[b, str] = issupported(this);

if b,
    if isa(this.filter, 'mfilt.abstractcic')
        set(this, 'DisabledTabs', 1);
    else

        if ~any(strcmpi(this.FilterInternals, {'specify all', 'full'}))
            set(this, 'FilterInternals', 'full');
        end
        
        if isa(this.filter, 'mfilt.holdinterp')
            set(this, 'DisabledTabs', [1 3]);
        else
            set(this, 'DisabledTabs', []);
        end
    end

    % Update the GUI with the new settings
    info = qtoolinfo(filter);

    if ~isempty(info)

        if isfield(info, 'normalize'), info = rmfield(info, 'normalize'); end
        if isfield(info, 'filterinternals'), info = rmfield(info, 'filterinternals'); end

        fn = fieldnames(info);

        ho = getcomponent(this, 'tag', 'output');
        set(ho, 'AutoScaleAvailable', 'On');

        hs = getcomponent(this, 'tag', 'state');
        set(hs, 'WordLabel2', '', 'AutoScaleAvailable', 'Off', 'Name', 'State');

        hp = getcomponent(this, 'tag', 'product');
        set(hp, 'ModeAvailable', 'On');

        ha = getcomponent(this, 'tag', 'accum');
        set(ha, 'ModeAvailable', 'On');

        % Set up all the objects that are used by this filter.
        for indx = 1:length(fn)
            h = getcomponent(this, 'tag', fn{indx});
            if ~isempty(info.(fn{indx}))
                if ~isempty(info.(fn{indx}).setops),
                    set(h, info.(fn{indx}).setops{:});
                end
            end
        end
    end

    if isrendered(this),
        visible_listener(this);
    end
    
    if strcmpi(filter.Arithmetic, 'fixed'),
        % If already fixed update the UI with the filters settings.
        filt2ui(this);
        set(this, 'Arithmetic', 'fixed');
    elseif strcmpi(filter.Arithmetic, 'single') && ~strcmpi(this.Arithmetic,'fixed-point')
      % If single, then if the UI is not fixed, set the UI to single. We
      % let the UI fixed point settings dominate on non-fixed point
      % filters. 
        set(this, 'Arithmetic', 'single');
        send(this, 'NewSettings');
    else
        % If not fixed, update the filter's settings with the UI.
        set(filter, 'Arithmetic', maparith(this));

        if strcmpi(filter.Arithmetic, 'fixed')
            if this.isApplied,
                apply(this);
            else
                state2filt(this);
            end
        else
            send(this, 'NewSettings');
        end
    end

    updateinputoutput(this);
else
    if isrendered(this)
        visible_listener(this);
    end
    set(this, 'Arithmetic', 'Double');
end

% [EOF]
