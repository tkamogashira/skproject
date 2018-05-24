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
        'CoeffFracLength';...
        'Signed'};
end
inprop = {'InputWordLength';...
    'InputFracLength'};
outprop = {'OutputWordLength';...
    'OutputMode'};
if strcmpi(this.OutputMode, 'SpecifyPrecision'),
    outprop = [outprop;{'OutputFracLength'}];
end

modes = {'RoundMode';'OverflowMode'};

siguddutils('dispstr', this, {coeffprop, inprop, outprop, modes}, varargin{:});

% [EOF]
