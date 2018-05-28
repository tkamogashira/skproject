function id = isdivider(m,n)
% isdivider - test whether one number divides another
%    isdivider(M,N) returns true when M divides N, false otherwise.
%    M and N must be positive integers not exceeding 2^32.
%
%   See also FACTOR.

% factor fcn tests for integrity & max value.
fm = factor(m);
fn = factor(n);
[c,im,in] = setxor(fm,fn);
id = isempty(im) || isequal(1,m);

