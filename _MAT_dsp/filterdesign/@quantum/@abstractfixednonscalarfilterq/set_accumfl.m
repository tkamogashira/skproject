function accumfl = set_accumfl(this, accumfl, prop)
%SET_ACCUMFL   PreSet function for the 'AccumFracLength' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Some subclasses refer to this as 'AccumNumFracLength', allow them to
% customize the error message.
if nargin < 3
    prop = 'AccumFracLength';
end

if ~strcmpi(this.AccumMode, 'SpecifyPrecision')
    siguddutils('readonlyerror', prop, 'AccumMode', 'SpecifyPrecision');
end

try
    this.fimath.SumFractionLength = accumfl;
catch
    error(message('dsp:quantum:abstractfixednonscalarfilterq:set_accumfl:MustBeInteger'));
end

% Update the downstream automagic.
updateinternalsettings(this);

% Store nothing to avoid duplicate data.
accumfl = [];

% [EOF]
