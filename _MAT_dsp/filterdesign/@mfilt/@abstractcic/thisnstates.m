function n = thisnstates(Hm)
%NSTATES  Number of states in discrete-time filter.
%   NSTATES(Hm) returns the number of states in the
%   discrete-time filter Hm.  The number of states depends 
%   on the filter structure.
  
%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

% Integrator states + comb states 
n = Hm.NumberOfSections + (Hm.DifferentialDelay*Hm.NumberOfSections);

% [EOF]
