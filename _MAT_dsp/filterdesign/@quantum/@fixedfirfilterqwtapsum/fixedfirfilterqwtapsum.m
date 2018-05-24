function this = fixedfirfilterqwtapsum
%FIXEDFIRFILTERQWTAPSUM   Construct a FIXEDFIRFILTERQWTAPSUM object.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this = quantum.fixedfirfilterqwtapsum;

% Force the default AccumWordLength
this.AccumWordLength = 40;

% [EOF]
