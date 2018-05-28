function vn = VnextPow2(x);
% VNEXTPOW2 - vectorial version of nextpow2
%   identical to MatLab's nextpow2, except that
%   for a vector X, VNEXTPOWER(X) is the element-wise
%   nextpow2 rather than nextpow2(size(X)).

vn = ceil(log2(x));