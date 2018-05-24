function info = qtoolinfo(~)
%QTOOLINFO   

%   Copyright 1999-2012 The MathWorks, Inc.

info.output.setops = {'AutoScaleAvailable', 'Off'};

info.product.setops  = {'ModeAvailable', 'Off', 'FracLabels', {'Product'}};

info.accum.setops  = {'ModeAvailable', 'Off', 'FracLabels', {'Accum.'}};

info.coeff.setops  = {'Name', 'Numerator', 'FracLabels', {'Numerator'}};
info.coeff.syncops = {'Num'};

info.filterinternals = true;

% [EOF]
