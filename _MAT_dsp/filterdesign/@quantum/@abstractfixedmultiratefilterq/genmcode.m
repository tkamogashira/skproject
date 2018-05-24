function hcode = genmcode(this)
%GENMCODE   Generate an MATLAB code object for this object.

%   Author(s): J. Schickler
%   Copyright 1999-2009 The MathWorks, Inc.

hcode = sigcodegen.mcodebuffer;

hcode.addcr('    ''CoeffWordLength'', %d, ...', this.CoeffWordLength);
hcode.addcr('    ''CoeffAutoScale'', %s, ...', mat2str(this.CoeffAutoScale));

if ~this.CoeffAutoScale
    hcode.addcr('    ''NumFracLength'', %d, ...', this.NumFracLength);
end

hcode.addcr('    ''Signed'', %s, ...', mat2str(this.Signed));
hcode.addcr('    ''InputWordLength'', %d, ...', this.InputWordLength);
hcode.addcr('    ''InputFracLength'', %d, ...', this.InputFracLength);
hcode.add('    ''FilterInternals'', ''%s''', this.FilterInternals);

if strcmpi(this.FilterInternals, 'fullprecision')
    hcode.add(');');
else
    hcode.addcr(', ...');
    hcode.addcr('    ''OutputWordLength'', %d, ...', this.OutputWordLength);
    hcode.addcr('    ''OutputFracLength'', %d, ...', this.OutputFracLength);
    hcode.addcr('    ''AccumWordLength'', %d, ...', this.AccumWordLength);
    hcode.addcr('    ''AccumFracLength'', %d, ...', this.AccumFracLength);
    hcode.addcr('    ''RoundMode'', ''%s'', ...', this.RoundMode);
    hcode.addcr('    ''OverflowMode'', ''%s'');', this.OverflowMode);
end

% [EOF]
