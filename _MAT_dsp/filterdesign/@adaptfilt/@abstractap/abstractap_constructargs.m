function args = abstractap_constructargs(Ha)
%ABSTRACTAP_CONSUCTARGS Returns the inputs to the constructor

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

args = {'FilterLength', 'StepSize', 'ProjectionOrder', 'Offset', ...
        'Coefficients', 'States'};

% [EOF]
