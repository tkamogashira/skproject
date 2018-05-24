function args = constructargs(Ha)
%CONSUCTARGS Returns the inputs to the constructor

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

args = abstractap_constructargs(Ha);

args = {args{:}, 'CorrelationCoeffs', 'ErrorStates', 'EpsilonStates'};

% Put in a dumby value.
args{4} = 5;

% [EOF]
