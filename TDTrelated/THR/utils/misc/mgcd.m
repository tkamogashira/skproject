function g = mgcd(A);
% mgcd - greatest commopn divisor of an array of numbers
%    mgcd(A) returns the gcd of the elements of array  A.
%
%    See also GCD.

g = A(1);
for ii=2:numel(A),
    g = gcd(g,A(ii));
end


