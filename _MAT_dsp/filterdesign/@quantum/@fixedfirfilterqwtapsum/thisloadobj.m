function thisloadobj(this, s)
%THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

fir_thisloadobj(this, s);

set(this, 'TapSumMode', s.TapSumMode);

switch lower(this.TapSumMode)
    case {'keeplsb','keepmsb'}
        set(this, 'TapSumWordLength', s.TapSumWordLength);
    case 'specifyprecision'
        set(this, ...
            'TapSumWordLength', s.TapSumWordLength, ...
            'TapSumFracLength', s.TapSumFracLength);
end

% [EOF]
