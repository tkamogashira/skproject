function thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

super_thisautoscale(this,s,binptaligned);

% States
this.privstatefl = getautoscalefl(this,s.States,true,this.StateWordLength);

% [EOF]
