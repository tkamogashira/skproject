function h = fir_genmcode(this)
%FIR_GENMCODE   Generate MATLAB code.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

h = out_genmcode(this);

% Add the Product information
h.add(', ...\n    ''ProductMode'', ''%s''', this.ProductMode);
switch lower(this.ProductMode)
    case 'fullprecision'
        % NO OP
    case {'keepmsb', 'keeplsb'}
        h.add(', ...\n    ''ProductWordLength'', %d', this.ProductWordLength);
    case 'specifyprecision'
        h.add(', ...\n    ''ProductWordLength'', %d', this.ProductWordLength);
        h.add(', ...\n    ''ProductFracLength'', %d', this.ProductFracLength);
end

% Add the Accumulator information
h.add(', ...\n    ''AccumMode'', ''%s''', this.AccumMode);
switch lower(this.AccumMode)
    case 'fullprecision'
        % NO OP
    case {'keepmsb', 'keeplsb'}
        h.add(', ...\n    ''AccumWordLength'', %d', this.AccumWordLength);
        h.add(', ...\n    ''CastBeforeSum'', %s', mat2str(this.CastBeforeSum));
    case 'specifyprecision'
        h.add(', ...\n    ''AccumWordLength'', %d', this.AccumWordLength);
        h.add(', ...\n    ''AccumFracLength'', %d', this.AccumWordLength);
        h.add(', ...\n    ''CastBeforeSum'', %s', mat2str(this.CastBeforeSum));
end

h.add(', ...\n    ''CoeffAutoScale'', %s', mat2str(this.CoeffAutoScale));
h.add(', ...\n    ''CoeffWordLength'', %d', this.CoeffWordLength);

% [EOF]
