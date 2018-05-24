function h = iir_genmcode(this)
%IIR_GENMCODE   IIR specific mcode.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

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
        h.add(', ...\n    ''NumProdFracLength'', %d', this.NumProdFracLength);
        h.add(', ...\n    ''DenProdFracLength'', %d', this.DenProdFracLength);
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
        h.add(', ...\n    ''NumAccumFracLength'', %d', this.NumAccumFracLength);
        h.add(', ...\n    ''DenAccumFracLength'', %d', this.DenAccumFracLength);
        h.add(', ...\n    ''CastBeforeSum'', %s', mat2str(this.CastBeforeSum));
end

% Add the coefficient information
h.add(', ...\n    ''CoeffAutoScale'', %s', mat2str(this.CoeffAutoScale));
h.add(', ...\n    ''CoeffWordLength'', %d', this.CoeffWordLength);
if ~this.CoeffAutoScale
    h.add(', ...\n    ''DenFracLength'', %d', this.DenFracLength);
    h.add(', ...\n    ''NumFracLength'', %d', this.NumFracLength);
end

% [EOF]
