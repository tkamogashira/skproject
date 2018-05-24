function h = double(this)
%DOUBLE   Cast filter to a double-precision arithmetic version.
%   See help in dfilt/double.

%   Author(s): R. Losada
%   Copyright 2003-2004 The MathWorks, Inc.

h=reffilter(this);
% Use quantized coefficients
h.Numerator = this.Numerator;

% [EOF]
