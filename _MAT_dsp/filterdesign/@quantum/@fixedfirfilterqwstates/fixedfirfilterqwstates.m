function this = fixedfirfilterqwstates
%FIXEDFIRFILTERQWSTATES   Construct a FIXEDFIRFILTERQWSTATES object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixedfirfilterqwstates;

% Force the default AccumWordLength
this.AccumWordLength = 40;

% [EOF]
