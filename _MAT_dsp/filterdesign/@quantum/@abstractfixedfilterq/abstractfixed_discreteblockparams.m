function p = abstractfixed_discreteblockparams(this)
%ABSTRACTFIXED_DISCRETEBLOCKPARAMS   Return the generic settings for blocks
%in simulink/Discrete library

%   Copyright 2012 The MathWorks, Inc.

s = get(this);

p.OutDataTypeStr = sprintf('fixdt(true,%d,%d)',s.OutputWordLength,s.OutputFracLength);

switch lower(this.RoundMode)
    case 'fix'
        p.RndMeth = 'Zero';
    case 'floor'
        p.RndMeth = 'Floor';
    case 'ceil'
        p.RndMeth = 'Ceiling';
    case 'round'
        p.RndMeth = 'Round';
    case 'convergent'
        p.RndMeth = 'Convergent';
    case 'nearest'
         p.RndMeth = 'Nearest';
end

if strcmpi(this.OverflowMode, 'Saturate')
    p.SaturateOnIntegerOverflow = 'on';
else
    p.SaturateOnIntegerOverflow = 'off';
end
