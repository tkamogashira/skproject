function state2filt(this)
%STATE2FILT   Set up the filter to match the ui.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

sendstatus(this, 'Quantizing Filter ...');

Hd = get(this, 'Filter');

s = get(this, 'prevAppliedState');

if isa(Hd, 'mfilt.abstractcic')
    
    % Set the cic properties which are always present.
    set(Hd, ...
        'FilterInternals',  mapCICFilterInternals(this.FilterInternals), ...
        'OutputWordLength', s.output.wordlength, ...
        'InputWordLength',  s.input.wordlength, ...
        'InputFracLength',  s.input.fraclengths{1});
    
    % If the SWLMode is "specify" then set the word lengths.
    if any(strcmpi(Hd.FilterInternals, {'specifyprecision', 'specifywordlengths'}))
        set(Hd, 'SectionWordLengths', evaluatevars(this.SectionWordLengths));
    end
    
    if strcmpi(Hd.FilterInternals, 'specifyprecision')
        set(Hd, ...
            'SectionFracLengths', evaluatevars(this.SectionFracLengths), ...
            'OutputFracLength',   s.output.fraclengths{1});
    end
    
    % Set up the GUI to reflect the object.
    setGUIvals(getcomponent(this, 'input'), Hd, 'input');
    setGUIvals(getcomponent(this, 'output'), Hd, 'output');
    
    updatecicinfo(this);
elseif isa(Hd, 'mfilt.holdinterp')
    set(Hd, 'InputWordLength', s.input.wordlength, ...
        'InputFracLength', s.input.fraclengths{1});
    
    ho = getcomponent(this, 'output');
    set(ho, 'WordLength', sprintf('%d', Hd.OutputWordLength), ...
        'FracLengths', {sprintf('%d', Hd.OutputFracLength)});
else

    info = qtoolinfo(Hd);

    % These aren't required so we have to add them ourselves.
    info.input.syncops  = [];
    info.output.syncops = [];

    if isfield(info, 'normalize'), 
        hasnormalize = true;
        info = rmfield(info, 'normalize');
    else
        hasnormalize = false;
    end

    if ~isfield(info, 'filterinternals')
        info.filterinternals = false;
    end
    
    if info.filterinternals
        
        % Sync the Coefficients.
        syncGUIvals(getcomponent(this, 'tag', 'coeff'), Hd, 'coeff', s.coeff);
        set(Hd, 'Signed', strcmpi(s.signed, 'on'));        
        
        % Sync the Input.
        syncGUIvals(getcomponent(this, 'tag', 'input'), Hd, 'input', s.input);
        
        set(Hd, 'FilterInternals', this.FilterInternals(1:3));
        if strncmpi(this.FilterInternals, 'spec', 4)
            set(Hd, 'OutputWordLength', s.output.wordlength, ...
                'OutputFracLength', s.output.fraclengths{1}, ...
                'AccumWordLength', s.accum.wordlength, ...
                'AccumFracLength', s.accum.fraclengths{1}, ...
                'RoundMode', s.roundmode, ...
                'OverflowMode', s.overflowmode);
            if isfield(info, 'product')
                if ~isempty(info.product)
                    set(Hd, 'ProductWordLength', s.product.wordlength, ...
                        'ProductFracLength', s.product.fraclengths{1});
                end
            end
        end
        
        % Normalize or denormalize the filter.
        if hasnormalize
            if strcmpi(s.normalize, 'on')
                normalize(Hd);
            else
                denormalize(Hd);
            end
        end
        
        % Set the coefficient quantizers
        setGUIvals(getcomponent(this, 'coeff'), Hd, 'coeff');

        % Set the input quantizers
        setGUIvals(getcomponent(this, 'input'), Hd, 'input');
        
        set(this, 'FilterInternals', mapObjFilterInternals(Hd.FilterInternals));
        
        % Set the output
        setGUIvals(getcomponent(this, 'output'), Hd, 'output');

        % Set the accumulator with the values from the filter in case we
        % are in full precision.  This will cause the GUI to update with
        % the new values determined by the filter.
        ha = getcomponent(this, 'accum');
        set(ha, ...
            'WordLength', sprintf('%d', Hd.AccumWordLength), ...
            'FracLengths', {sprintf('%d', Hd.AccumFracLength), ha.FracLengths{2:end}});

        % Set the product
        hp = getcomponent(this, 'product');
        set(hp, ...
            'WordLength', sprintf('%d', Hd.ProductWordLength), ...
            'FracLengths', {sprintf('%d', Hd.ProductFracLength), hp.FracLengths{2:end}});
    else

        if isfield(info, 'filterinternals'), info = rmfield(info, 'filterinternals'); end
        f = fieldnames(info);

        for indx = 1:length(f)
            cf = f{indx};
            h = getcomponent(this, 'tag', cf);
            if ~isempty(info.(cf))
                syncGUIvals(h, Hd, cf, s.(cf));
            end
        end

        % Sync the rest of the properties.
        set(Hd, ...
            'signed',        strcmpi(s.signed, 'on'), ...
            'RoundMode',     s.roundmode, ...
            'OverflowMode',  s.overflowmode);

        hasaccum = true;
        if isfield(info, 'accum')
            if isempty(info.accum)
                hasaccum = false;
            end
        end
        if hasaccum
            if ~strncmpi(Hd.AccumMode, 'Full', 4)
                Hd.CastBeforeSum = strcmpi(s.castbeforesum, 'on');
            end
        end

        % Normalize or denormalize the filter.
        if hasnormalize
            if strcmpi(s.normalize, 'on')
                normalize(Hd);
            else
                denormalize(Hd);
            end
        end

        % Loop over again and update the autoscaled properties.
        for indx = 1:length(f)
            cf = f{indx};
            h = getcomponent(this, 'tag', cf);
            if ~isempty(info.(cf))
                updateautoscale(h, Hd, cf);
            end
        end
    end
end

send(this, 'NewSettings');

sendstatus(this, 'Quantizing Filter ... done');

% -------------------------------------------------------------------------
function obj = mapObjFilterInternals(FI)
% Map filter object filter internals to the object names

switch lower(FI)
    case 'fullprecision'
        obj = 'full';
    case 'specifyprecision'
        obj = 'specify all';
    case 'specifywordlengths'
        obj = 'specify word lengths';
    case 'minwordlengths'
        obj = 'minimum section word lengths';
end

% -------------------------------------------------------------------------
function cic = mapCICFilterInternals(FI)
% Map the Object filter internals to CIC names

switch lower(FI)
    case 'full'
        cic = 'fullprecision';
    case 'specify all'
        cic = 'specifyprecision';
    case 'specify word lengths'
        cic = 'specifywordlengths';
    case 'minimum section word lengths'
        cic = 'minwordlengths';
end

% [EOF]
