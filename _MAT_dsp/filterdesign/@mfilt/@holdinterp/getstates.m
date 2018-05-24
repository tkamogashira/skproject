function S = getstates(this,S)
%GETSTATES   Get the states.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

S = this.HiddenStates;
S = reshape(S,0,1);

% [EOF]
