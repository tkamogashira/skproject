function p = sos_blockparams(this)
%SOS_BLOCKPARAMS   Returns the sos block parameters.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = abstractfixed_blockparams(this);

s = internalsettings(this);

p.accumMode          = 'Binary point scaling';
p.accumWordLength    = sprintf('%d', s.AccumWordLength);
p.accumFracLength    = sprintf('%d', s.NumAccumFracLength);
p.denAccumFracLength = sprintf('%d', s.DenAccumFracLength);

p.prodOutputMode          = 'Binary point scaling';
p.prodOutputWordLength    = sprintf('%d', s.ProductWordLength);
p.prodOutputFracLength    = sprintf('%d', s.NumProdFracLength);
p.denProdOutputFracLength = sprintf('%d', s.DenProdFracLength);

p.firstCoeffMode       = 'Binary point scaling';
p.firstCoeffWordLength = sprintf('%d', s.CoeffWordLength);
p.firstCoeffFracLength = sprintf('%d', s.NumFracLength);

p.secondCoeffFracLength = sprintf('%d', s.DenFracLength);

p.scaleValueFracLength = sprintf('%d', s.ScaleValueFracLength);

% [EOF]
