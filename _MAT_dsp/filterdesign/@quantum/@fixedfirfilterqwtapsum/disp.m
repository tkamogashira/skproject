function disp(this, varargin)
%DISP Object display.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Re-order quantizers
if this.CoeffAutoScale,
    coeffprop = {'CoeffWordLength';...
        'CoeffAutoScale';...
        'Signed'};
else
    coeffprop = {'CoeffWordLength';...
        'CoeffAutoScale';...
        'NumFracLength';...
        'Signed'};
end
inprop = {'InputWordLength';...
    'InputFracLength'};
outprop = {'OutputWordLength';...
    'OutputMode'};
if strcmpi(this.OutputMode, 'SpecifyPrecision'),
    outprop = [outprop;{'OutputFracLength'}];
end

tapsumprop = {'TapSumMode'};
if strcmpi(this.TapSumMode, 'SpecifyPrecision'),
    tapsumprop = [tapsumprop;...
        {'TapSumWordLength';...
        'TapSumFracLength'}];
elseif strncmpi(this.TapSumMode, 'Keep',4),
    tapsumprop = [tapsumprop;{'TapSumWordLength'}];
end

prodprop = {'ProductMode'};
if strcmpi(this.ProductMode, 'SpecifyPrecision'),
    prodprop = [prodprop;...
        {'ProductWordLength';...
        'ProductFracLength'}];
elseif strncmpi(this.ProductMode, 'Keep',4),
    prodprop = [prodprop;{'ProductWordLength'}];
end

modes = {'RoundMode';'OverflowMode'};
accprop = {'AccumMode'};
if strcmpi(this.AccumMode, 'SpecifyPrecision'),
    accprop = [accprop;...
        {'AccumWordLength';...
        'AccumFracLength'}];
    modes = {'CastBeforeSum';'RoundMode';'OverflowMode'};
elseif strncmpi(this.AccumMode, 'Keep',4),
    accprop = [accprop;{'AccumWordLength'}];
    modes = {'CastBeforeSum';'RoundMode';'OverflowMode'};
end

siguddutils('dispstr', this, {coeffprop, inprop, outprop, tapsumprop, ...
    prodprop, accprop, modes}, varargin{:});

% [EOF]
