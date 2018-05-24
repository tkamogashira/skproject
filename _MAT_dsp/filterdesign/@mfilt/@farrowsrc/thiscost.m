function [NMult,NAdd,NStates,MPIS,APIS] = thiscost(this,M)
%THISCOST   

%   Copyright 2007 The MathWorks, Inc.

NMult = nmult(this,true,true);
NAdd = nadd(this);
R = getratechangefactors(this);

MPIS = NMult*R(1)/M;
APIS = NAdd*R(1)/M; 
NStates = nstates(this);

% [EOF]
