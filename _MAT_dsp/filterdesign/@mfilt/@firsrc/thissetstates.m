function S = thissetstates(Hm,S)
%THISSETSTATES Overloaded set for the States property.

% This should be a private method

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

if isempty(S),
    % Prepended the state vector with one extra zero per channel
    S = nullstate1(Hm.filterquantizer);
else
    % Check data type, quantize if needed
    S = validatestates(Hm.filterquantizer, S);
    % Prepended the state vector with one extra zero per channel
    S = prependzero(Hm.filterquantizer, S);
end

% Reset the TapIndex
Hm.TapIndex = 0;

% Store hidden states
Hm.HiddenStates = S;

% Don't duplicate
S = [];

