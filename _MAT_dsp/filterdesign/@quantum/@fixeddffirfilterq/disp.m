function disp(this, varargin)
%DISP Object display.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Re-order properties
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

internalsprop = {'FilterInternals'};

if strcmpi(this.FilterInternals,'SpecifyPrecision'),
    outprop = {'OutputWordLength',...
        'OutputFracLength'};
    modes = {'RoundMode',...
        'OverflowMode'};
    prodprop = {'ProductWordLength';...
        'ProductFracLength'};
    accprop = {'AccumWordLength';...
        'AccumFracLength'};

    siguddutils('dispstr', this, {coeffprop, inprop, internalsprop, outprop, ...
        prodprop, accprop, modes}, varargin{:});
else
    siguddutils('dispstr', this, {coeffprop, inprop, internalsprop}, varargin{:});
end

% [EOF]
