function thisautoscale(this,s,binptaligned)
%THISAUTOSCALE   

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

inputautoscalefl(this,s,binptaligned)
outputautoscalefl(this,s,binptaligned)

this.NumStateFracLength = getautoscalefl(this,s.NumStates,true,this.StateWordLength);
this.DenStateFracLength = getautoscalefl(this,s.DenStates,true,this.StateWordLength);

this.MultiplicandFracLength = getautoscalefl(this,s.Multiplicand,true,this.MultiplicandWordLength);

superdf1t_thisautoscale(this,s,binptaligned);

% [EOF]
