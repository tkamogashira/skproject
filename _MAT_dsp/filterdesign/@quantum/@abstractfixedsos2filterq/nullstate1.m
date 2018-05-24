function S = nullstate1(q)
%NULLSTATE1   

%   Author(s): V. Pellissier
%   Copyright 1999-2005 The MathWorks, Inc.

stWL = q.StateWordLength;
stFL = q.StateFracLength;
F = fimath('RoundMode', 'nearest', 'OverflowMode' , 'saturate');
S = fi(0, 'Signed', true, 'WordLength', stWL, ...
    'FractionLength', stFL, 'fimath', F);

% [EOF]
