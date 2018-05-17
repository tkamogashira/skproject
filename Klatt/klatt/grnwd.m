function x = grnwd(F, A, a, k)
%GRNWD Greenwood cochlear frequency-position function.
%   X = GRNWD(F, A, a, K) returns the cochlear position X in milimeters based on
%   the frequency F and species specific constants A, a, and K where
%   A is the high-frequency limit constant
%   a is the slope constant devided by the cochlear length in milimeters
%   K is the low-frequency constant
%
%   X = GRNWD(species) where species is one of 'human', 'cat', 'chinchilla', 
%   'gerbil', 'guinea pig', 'macaque', 'oppossum', 'mouse', 'rat', 'cow', or
%   'elephant' uses constants specific to that species.

%   Copyright (c) 2001 by Michael Kiefte

if nargin == 2
    [A a k] = grnwdspc(A);
end

x = 1./a .* log10(F./A + k);
