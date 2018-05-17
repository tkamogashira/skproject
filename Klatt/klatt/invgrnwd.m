function F = invgrnwd(x, A, a, k)
%INVGRNWD Inverse of Greenwood cochlear frequency-position function
%   F = INVGRNWD(X, A, a, K) returns the frequency related to the cochlear position
%   X on the bases of the species-specific constants A, a, and K.
%
%   F = INVGRNWD(X, SPECIES) uses the constants returned from GRNWDSPC.

%   Copyright (c) 2001 by Michael Kiefte.

if nargin == 2
    [A a k] = grnwdspc(A);
end

F = A.*(10.^(a.*x) - k);
