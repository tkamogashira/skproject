function [new_ext,newidx] = extremals(this,fgrid,errgrid)
%EXTREMALS   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Compute extremals


% Ensure that band edges are retained
max_ext = [local_max(errgrid(2:end))];
min_ext = [local_max(-errgrid(2:end))];

newidx = sort([max_ext,min_ext]);

new_ext = [0,fgrid(newidx+1)];

%----------------------------------------
function k = local_max(x)
% k = local_max(x)
% finds location of local maxima
%
% Modified version of the one in signal/private

% Don't include maxima if value is negative
x(x<=0) = 0;

M = length(x);
x1 = x(1:M-1); 
x2 = x(2:M);
b1 = (x1<=x2); b2 = (x1>x2);
k = find(b1(1:M-2)&b2(2:M-1))+1;
if x(1)>x(2), k = [k, 1]; end
if x(M)>x(M-1), k = [k, M]; end
k = sort(k); 

% [EOF]
