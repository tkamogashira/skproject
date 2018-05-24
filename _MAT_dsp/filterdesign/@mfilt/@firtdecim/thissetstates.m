function S = thissetstates(Hm,S)
%THISSETSTATES Overloaded set for the States property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Check data type, quantize if needed
S = validatestates(Hm.filterquantizer, S);

Hm.HiddenStates = S;

