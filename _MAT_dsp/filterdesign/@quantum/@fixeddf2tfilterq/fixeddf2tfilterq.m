function this = fixeddf2tfilterq
%FIXEDDF2TFILTERQ   Construct a FIXEDDF2TFILTERQ object.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixeddf2tfilterq;

% Create a default number of coefficients
this.ncoeffs = [1 1];

% Force the default AccumWordLength
this.AccumWordLength = 40;

% [EOF]
