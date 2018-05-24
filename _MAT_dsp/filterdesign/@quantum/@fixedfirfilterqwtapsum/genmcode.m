function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = fir_genmcode(this);

if ~this.CoeffAutoScale
    h.add(', ...\n    ''NumFracLength'', %d', this.NumFracLength);
end

h.add(', ...\n    ''TapSumMode'', ''%s''', this.TapSumMode);

switch lower(this.TapSumMode)
    case 'fullprecision'
        % NO OP
    case {'keepmsb', 'keeplsb'}
        h.add(', ...\n    ''TapSumWordLength'', %d', this.TapSumWordLength);
    case 'specifyprecision'
        h.add(', ...\n    ''TapSumWordLength'', %d', this.TapSumWordLength);
        h.add(', ...\n    ''TapSumFracLength'', %d', this.TapSumFracLength);
end

% [EOF]
