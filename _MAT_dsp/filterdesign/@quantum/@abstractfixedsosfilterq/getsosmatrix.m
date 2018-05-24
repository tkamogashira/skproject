function sosmatrix = getsosmatrix(q, num, den)
%GETSOSMATRIX 

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

sosmatrix = [double(num) double(den)];
% Substitute 4th column with 1s
sosmatrix(:,4) = 1;

% [EOF]
