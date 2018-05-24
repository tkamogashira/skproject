function p = abstractfixed_blockparams(this)
%ABSTRACTFIXED_BLOCKPARAMS   Return the generic settings.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

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
    s = 'on';
else
    s = 'off';
end

p.roundingMode = RndMeth;
p.overflowMode = s;

% [EOF]
