function filt2ui(this)
%FILT2UI   Set the UI to match the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

Hd = get(this, 'Filter');

if isa(Hd, 'mfilt.abstractcic')
    h = getcomponent(this, 'input');

    set(h, 'WordLength', sprintf('%d', Hd.InputWordLength), ...
        'FracLengths', {sprintf('%d', Hd.InputFracLength)});
    h = getcomponent(this, 'output');
    set(h, 'WordLength', sprintf('%d', Hd.OutputWordLength), ...
        'FracLengths', {sprintf('%d', Hd.OutputFracLength)});
    
    set(this, 'FilterInternals', lclMapFromCIC(Hd.FilterInternals), ...
        'SectionWordLengths', mat2str(Hd.SectionWordLengths), ...
        'SectionFracLengths', mat2str(Hd.SectionFracLengths));

elseif isa(Hd, 'mfilt.holdinterp')
    setGUIvals(getcomponent(this, 'input'), Hd, 'input');
else

    info = qtoolinfo(Hd);
    info.input.syncops  = [];
    info.output.syncops = [];

    if isfield(info, 'normalize'), info = rmfield(info, 'normalize'); end
    if isfield(info, 'filterinternals')

        % Set the coefficient quantizers
        setGUIvals(getcomponent(this, 'coeff'), Hd, 'coeff');

        % Set the input quantizers
        setGUIvals(getcomponent(this, 'input'), Hd, 'input');

        set(this, 'FilterInternals', lclMapFromCIC(Hd.FilterInternals));

        set(getcomponent(this, 'output'), ...
            'WordLength', sprintf('%d', Hd.OutputWordLength), ...
            'FracLengths', {sprintf('%d', Hd.OutputFracLength)});

        % Set the accumulator
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
        f = fieldnames(info);

        for indx = 1:length(f)
            cf = f{indx};
            h  = getcomponent(this, cf);
            if ~isempty(info.(cf))
                setGUIvals(h, Hd, cf);
            end
        end
    end

    if Hd.Signed,
        unsigned = 'Off';
    else
        unsigned = 'On';
    end

    set(this, 'RoundMode', convertroundmode(Hd), ...
        'OverflowMode', get(Hd, 'OverflowMode'), ...
        'Unsigned', unsigned, ...
        'isApplied', true);

    if isfield(info, 'accum')
        if isempty(info.accum)
            return;
        end
    end
    if ~(isfilterinternals(this) || strcmpi(Hd.AccumMode, 'Full'))
        if Hd.CastBeforeSum
            cbs = 'On';
        else
            cbs = 'Off';
        end
        set(this, 'CastBeforeSum', cbs);
    end
end

% -------------------------------------------------------------------------
function roundmode = convertroundmode(Hd)

switch lower(Hd.Roundmode)
    case 'ceil'
        roundmode = 'ceiling';
    case 'floor'
        roundmode = 'floor';
    case 'fix'
        roundmode = 'zero';
    case 'round'
        warning(message('dsp:fdtbxgui:qtool:filt2ui:InvalidRounding'));
        Hd.RoundMode = 'nearest';
        roundmode = 'nearest';
    case 'nearest'
        roundmode = 'nearest';
    case 'convergent'
        roundmode = 'nearest (convergent)';
end


% ------------------------------------------------------------------------- 
function objName = lclMapFromCIC(cicName) 
 
switch lower(cicName) 
    case 'fullprecision' 
        objName = 'full'; 
    case 'specifyprecision' 
        objName = 'specify all'; 
    case 'specifywordlengths' 
        objName = 'specify word lengths'; 
    case 'minwordlengths' 
        objName = 'minimum section word lengths'; 
end

% [EOF]
