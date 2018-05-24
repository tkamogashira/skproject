function this = limitcycle(limitcycle,zi,y,period,trial)
%LIMITCYCLE   Construct a LIMITCYCLE object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

this = quantum.limitcycle;
this.LimitCycle = limitcycle;
this.Zi = zi;
this.Output = y;
this.Period = period;
this.Trial = trial;
% [EOF]
