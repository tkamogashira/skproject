function p = blockparams(this, varargin)
%BLOCKPARAMS   Return the block params for the fixed point settings.

%   Copyright 1999-2012 The MathWorks, Inc.

s = get(this);

p.outputMode       = 'Binary point scaling';
p.outputWordLength = sprintf('%d', s.OutputWordLength);
p.outputFracLength = sprintf('%d', s.OutputFracLength);

switch lower(this.RoundMode)
    case 'fix'
        RndMeth = 'Zero';
    case 'floor'
        RndMeth = 'Floor';
    case 'ceil'
        RndMeth = 'Ceiling';
    case 'round'
        RndMeth = 'Round';
    case 'convergent'
        RndMeth = 'Convergent';
    case 'nearest'
        RndMeth = 'Nearest';
end

if strcmpi(this.OverflowMode, 'Saturate')
    om = 'on';
else
    om = 'off';
end

p.roundingMode = RndMeth;
p.overflowMode = om;

p.accumMode       = 'Binary point scaling';
p.accumWordLength = sprintf('%d', s.AccumWordLength);
p.accumFracLength = sprintf('%d', s.AccumFracLength);

p.prodOutputMode       = 'Binary point scaling';
p.prodOutputWordLength = sprintf('%d', s.ProductWordLength);
p.prodOutputFracLength = sprintf('%d', s.ProductFracLength);

p.firstCoeffMode       = 'Binary point scaling';
p.firstCoeffWordLength = sprintf('%d', s.CoeffWordLength);
p.firstCoeffFracLength = sprintf('%d', s.NumFracLength);
