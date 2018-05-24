function ic = getinitialconditions(Hd)
%GETINITIALCONDITIONS Get the initial conditions.

%   Copyright 2009 The MathWorks, Inc.

s = Hd.States;

ic.Integrator = double(s.Integrator);
ic.Comb = double(s.Comb);


% [EOF]
