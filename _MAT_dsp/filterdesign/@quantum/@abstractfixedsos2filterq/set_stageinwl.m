function stageinwl = set_stageinwl(this, stageinwl)
%SET_STAGEINWL   PreSet function for the 'stageinwl' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    this.privstageinwl = stageinwl;
catch
    error(message('dsp:quantum:abstractfixedsos2filterq:set_stageinwl:MustBePosInteger'));
end

% Update downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplication.
stageinwl = [];

% [EOF]
