function [NMult,NAdd,NStates,MPIS,APIS] = thiscost(this,M)
%THISCOST   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

NMult = 0;
NAdd = nadd(this);
MPIS = 0;
APIS = NAdd/2*(1+this.InterpolationFactor); 
NStates = nstates(this);

% [EOF]
