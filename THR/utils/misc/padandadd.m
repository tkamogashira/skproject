function A = padandadd(A,B,varargin);
% padandadd - add arrays of different lengths by padding zeros
%   padandadd(A,B) appends zeros to the shorter one of vectors A and B, and
%   adds them. If A is a row vector, a row vector is returned. Otherwise a
%   column vector is returned, independent of the "orientation" of B.
%   
%   padandadd(A,B,C, ..) pads & adds multiple arrays.
%   
%   See also SameSize.

if nargin>2, % handle recursively
    A = padandadd(A,B);
    A = padandadd(A,varargin{:});
    return;
end

if ~isvector(A) || ~isvector(B),
    error('Input args must be vectors');
end

[A, AwasRow] = TempColumnize(A);
B = TempColumnize(B);
NA = numel(A);
NB = numel(B);
if NA>=NB,
    A = A + [B; zeros(NA-NB,1)];
else,
    A = [A; zeros(NB-NA,1)] + B;
end
if AwasRow, A = A.'; end












