function b = lagrangecoeff(this,L,fext)
%LAGRANGECOEFF   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Compute lagrange coefficient
b = zeros(1,L); % preallocate
for k = 1:L,
    % Extract kth extremal
    extmk = [fext(1:k-1),fext(k+1:end)];
    b(k) = prod(1./(cos(fext(k)*pi)-cos(extmk*pi)));
end

% [EOF]
