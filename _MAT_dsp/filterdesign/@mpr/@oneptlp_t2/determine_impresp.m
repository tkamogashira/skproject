function b = determine_impresp(this)
%DETERMINE_IMPRESP   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

M = this.M;
N = M*2;

% Evaluate approximating polynomial at N+1 evenly spaced points
w = linspace(0,2-2/(N+1),N+1); % % Don't include factor of pi
Gw = evalapprox(this,w);

% Can evaluate as this
% bb = zeros(1,M+2);
% for n=0:M,
%     bb(n+1) = (Gw(1)+2*sum(Gw(2:M+1).*cos(2*pi*(1:M)*n/(N+1))))/(N+1);
% end
% 
% bc = .5*(bb(1:end-1)+bb(2:end));

% But use ifft instead to be faster
hz = ifft(Gw, 'symmetric'); % These are the modified coeffs
bc = .5*(hz(1:M+1)+[hz(2:M+1),0]);

b = [bc(end:-1:1),bc];

% [EOF]
