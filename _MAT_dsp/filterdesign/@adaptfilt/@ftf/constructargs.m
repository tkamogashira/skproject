function args = constructargs(Ha)
%CONSTRUCTARGS Returns the inputs to the constructor

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

args = {'FilterLength', 'ForgettingFactor', 'InitFactor', 'ConversionFactor', ...
        'KalmanGainStates', 'Coefficients', 'States'};

% [EOF]
