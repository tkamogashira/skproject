function [R,M,N] = params(this)
%PARAMS CIC filter parameters.

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(1,1,nargin,'struct'));

M = get(this,'DifferentialDelay');
N = get(this,'NumberOfSections');
R = get(this,'InterpolationFactor');

% [EOF]
