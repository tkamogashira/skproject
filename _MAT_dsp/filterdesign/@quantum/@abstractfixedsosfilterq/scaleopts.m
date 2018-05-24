function scaleopts(this,Hd,opts)
%SCALEOPTS   
%   Author(s): R. Losada
%   Copyright 2003-2006 The MathWorks, Inc.

% Determine Max numerator
as = Hd.CoeffAutoScale; % Cache value
Hd.CoeffAutoScale = false; % Temporarily set off
maxn = 2^(Hd.CoeffWordLength-Hd.NumFracLength-1);
if ~Hd.Signed,
    maxn = maxn*2;
end
opts.MaxNumerator = maxn;
Hd.CoeffAutoScale = as; % Reset value

% Set overflowmode
switch Hd.Overflowmode,
    case 'wrap',
        opts.OverflowMode = Hd.OverflowMode;
    case 'saturate',
        pm = Hd.ProductMode; % Cache value
        Hd.ProductMode = 'SpecifyPrecision';
        opts.OverflowMode = Hd.OverflowMode;
        Hd.ProductMode = pm; % Reset value
end


% [EOF]
