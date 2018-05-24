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

stateprop = {'StateWordLength';...
    'StateAutoScale'};
if ~this.StateAutoScale,
    stateprop = [stateprop;{'StateFracLength'}];
end

prodprop = {'ProductMode'};
if strcmpi(this.ProductMode, 'SpecifyPrecision'),
    prodprop = [prodprop;...
        {'ProductWordLength';...
        'ProductFracLength'}];
elseif strncmpi(this.ProductMode, 'Keep',4),
    prodprop = [prodprop;{'ProductWordLength'}];
end

accprop = {'AccumMode'};
if strcmpi(this.AccumMode, 'SpecifyPrecision'),
    accprop = [accprop;...
        {'AccumWordLength';...
        'AccumFracLength';...
        'CastBeforeSum'}];
elseif strncmpi(this.AccumMode, 'Keep',4),
    accprop = [accprop;{'AccumWordLength';'CastBeforeSum'}];
end
modes = {'RoundMode';'OverflowMode'};

siguddutils('dispstr', this, {coeffprop, inprop, outprop, stateprop, ...
    prodprop, accprop, modes}, varargin{:});

% [EOF]
