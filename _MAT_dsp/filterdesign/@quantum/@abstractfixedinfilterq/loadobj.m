function this = loadobj(s)
%LOADOBJ   Load the object.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

this = feval(s.class);

this.ncoeffs         = s.ncoeffs;
this.nphases         = s.nphases;

this.InputWordLength = s.InputWordLength;
this.InputFracLength = s.InputFracLength;

% [EOF]
