function accumwl = set_accumwl(this, accumwl)
%SET_ACCUMWL   PreSet function for the 'AccumWordLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

if strcmpi(this.AccumMode, 'FullPrecision')
    siguddutils('readonlyerror', 'AccumWordLength', 'AccumMode', ...
        'FullPrecision', false);
end

try
    if ~isempty(accumwl),
        this.fimath.SumWordLength = accumwl;
        this.fimath2.SumWordLength = accumwl;
    end
catch
    error(message('dsp:quantum:fixeddf1filterq:set_accumwl:MustBePosInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing here to avoid duplication.
accumwl = [];

% [EOF]
