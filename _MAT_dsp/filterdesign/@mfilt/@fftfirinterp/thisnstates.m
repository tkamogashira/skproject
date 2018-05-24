function n = thisnstates(Hm)
%NSTATES  Number of states in discrete-time filter.
%   NSTATES(Hm) returns the number of states in the
%   discrete-time filter Hm.
%
%   Author: R. Losada
%   Copyright 1999-2003 The MathWorks, Inc.

% States in overlap add filtering is the tail of the filtering result
% that is the overlap to be added.

L = Hm.interpolationFactor;
M = polyorder(Hm);

n = L*M;

% [EOF]
