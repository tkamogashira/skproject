function compute_err(this)
%COMPUTE_ERR   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;
Wext = this.Wext;
fext = this.fext;

% Compute b_k
b = lagrangecoeff(this,M+2,fext);

k = 1:M+2;
sgn = (-1).^(k+1);
this.analyticerr = b(1)/sum(b.*sgn./Wext);

% [EOF]
