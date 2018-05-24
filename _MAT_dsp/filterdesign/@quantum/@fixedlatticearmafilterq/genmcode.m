function h = genmcode(this)
%GENMCODE   Generate MATLAB code.

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
        h.add(', ...\n    ''LatticeProdFracLength'', %d', this.LatticeProdFracLength);
        h.add(', ...\n    ''LadderProdFracLength'', %d', this.LadderProdFracLength);
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
        h.add(', ...\n    ''LatticeAccumFracLength'', %d', this.LatticeAccumFracLength);
        h.add(', ...\n    ''LadderAccumFracLength'', %d', this.LadderAccumFracLength);
        h.add(', ...\n    ''CastBeforeSum'', %s', mat2str(this.CastBeforeSum));
end

% Add the coefficient information
h.add(', ...\n    ''CoeffAutoScale'', %s', mat2str(this.CoeffAutoScale));
h.add(', ...\n    ''CoeffWordLength'', %d', this.CoeffWordLength);
if ~this.CoeffAutoScale
    h.add(', ...\n    ''LadderFracLength'', %d', this.LadderFracLength);
    h.add(', ...\n    ''LatticeFracLength'', %d', this.LatticeFracLength);
end


% [EOF]
