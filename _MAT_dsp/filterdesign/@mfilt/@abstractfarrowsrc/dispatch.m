function Hd = dispatch(this)
%DISPATCH   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

L = this.InterpolationFactor;
if rem(L,1),
    error(message('dsp:mfilt:abstractfarrowsrc:dispatch:UndefinedTF'));
end
c = this.Coefficients;
refc = double(this.refcoeffs);
X = 0:1/L:(L-1)/L;
X = 1 - X;
Lp = size(c,1);
Nx = length(X);
num = zeros(Nx,Lp);
refnum = zeros(Nx,Lp);
for i=1:Lp,
    num(:,i) = polyval(c(i,:),X).';
    refnum(:,i) = polyval(refc(i,:),X).';
end   
Hd = lwdfilt.tf(num(:).');
Hd.refNum = refnum(:).';

% [EOF]
