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
        'DenFracLength';...
        'Signed'};
end
inprop = {'InputWordLength';'InputFracLength'};
outprop = {'OutputWordLength';'OutputFracLength'};

prodprop = {'ProductMode'};
if strcmpi(this.ProductMode, 'SpecifyPrecision'),
    prodprop = [prodprop;...
        {'ProductWordLength';...
        'NumProdFracLength';...
        'DenProdFracLength'}];
elseif strncmpi(this.ProductMode, 'Keep',4),
    prodprop = [prodprop;{'ProductWordLength'}];
end

accprop = {'AccumMode'};
if strcmpi(this.AccumMode, 'SpecifyPrecision'),
    accprop = [accprop;...
        {'AccumWordLength';...
        'NumAccumFracLength';...
        'DenAccumFracLength';...
        'CastBeforeSum'}];
elseif strncmpi(this.AccumMode, 'Keep',4),
    accprop = [accprop;{'AccumWordLength';'CastBeforeSum'}];
end
modes = {'RoundMode';'OverflowMode'};

siguddutils('dispstr', this, {coeffprop, inprop, outprop, prodprop, ...
    accprop, modes}, varargin{:});

% [EOF]
