function this = fixedfirfilterq
%FIXEDFIRFILTERQ   Construct a FIXEDFIRFILTERQ object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixedfirfilterq;

% Force the default AccumWordLength
this.AccumWordLength = 40;

% [EOF]
