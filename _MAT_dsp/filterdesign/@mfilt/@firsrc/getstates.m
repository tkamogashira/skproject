function S = getstates(Hm,dummy)
%GETSTATES Overloaded get for the States property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

Scir = Hm.HiddenStates;

% Circular -> Linear
tapIndex = Hm.tapIndex+1; %1-based indexing
S = [Scir(tapIndex+1:end,:); Scir(1:tapIndex-1,:)];
