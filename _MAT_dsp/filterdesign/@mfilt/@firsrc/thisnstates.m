function n = thisnstates(Hm)
%NSTATES  Number of states in discrete-time filter.
%   NSTATES(Hm) returns the number of states in the
%   discrete-time filter Hm.  The number of states depends on the filter
%   structure and the coefficients.
%
%   See also DFILT.   
  
%   Author: Thomas A. Bryan
%   Copyright 1999-2003 The MathWorks, Inc.

R = Hm.RateChangeFactors;
n = ceil(Hm.ncoeffs/R(1)) - 1;

