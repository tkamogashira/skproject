function args = constructargs(Ha)
%CONSUCTARGS Returns the inputs to the constructor

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

args = {'FilterLength', 'InitFactor', 'BlockLength', 'ConversionFactor', ...
        'KalmanGainStates', 'DesiredSignalStates', 'Coefficients', 'States'};

% [EOF]
