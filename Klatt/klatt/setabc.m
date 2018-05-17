function [a, b, c] = setabc(f, fb, pit)
%SETABC Formant frequency and bandwidth to filter coefficients.

%   Copyright (c) 2001 by Michael Kiefte.

r = exp(-pit*fb);
c = -r.^2;
b = 2*r.*cos(2*pit*f);
a = 1 - b - c;
if f >= 0 return, end

% if f is minus, compute a,b,c for a zero pair
a = 1./a;
b = -a.*b;
c = -a.*c;

