function arithmetic = setarithmetic(this, arithmetic)
%SETARITHMETIC   PreSet function for the 'arithmetic' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if issupported(this),
    arithmetictype = maparith(this, arithmetic);
    
    if strcmpi(arithmetictype,'fixed') && ~isfixptinstalled,
        error(message('dsp:fdtbxgui:qtool:setarithmetic:InvalidLicense'));
    end
    
    % Set the arithmetic, but make sure we use the new plug-ins.
    [wstr wid] = lastwarn;
    w = warning('off');
    set(this.Filter, 'Arithmetic',arithmetictype);
    lastwarn(wstr, wid)
    warning(w);
    
    updateinputoutput(this);
    if isa(this.Filter, 'mfilt.abstractcic')
        hi = getcomponent(this, 'input');
        set(hi, 'FracLengths', {'15'});
    end
    
    % Apply the settings.
    apply(this);
end

% [EOF]
