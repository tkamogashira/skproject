function Fo = cicnulls(R,D)
%CICNULLS   Compute frequencies of nulls of CIC.
%
%   Inputs:
%       R - Rate change factor
%       D - Differential delay
%
%   Outputs:
%       Fo - Normalized null frequencies between 0 and 1.


%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

f = 1:ceil((D*R-1)/2);
Fo = 2*f/(D*R); % Make normalized freq

% [EOF]
