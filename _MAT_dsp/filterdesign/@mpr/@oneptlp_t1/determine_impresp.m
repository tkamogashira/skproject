function b = determine_impresp(this)
%DETERMINE_IMPRESP   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;
N = M*2;

% Evaluate approximating polynomial at N+1 evenly spaced points
w = linspace(0,2-2/(N+1),N+1); % % Don't include factor of pi
Gw = evalapprox(this,w);

hz = ifft(Gw, 'symmetric');

b = [hz(M+2:end),hz(1:M+1)];


% [EOF]
