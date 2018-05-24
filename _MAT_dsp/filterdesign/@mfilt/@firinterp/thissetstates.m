function S = thissetstates(Hd,S)
%THISSETSTATES Overloaded set for the States property.

% This should be a private method

%   Author: R. Losada
%   Copyright 1988-2004 The MathWorks, Inc.

if isempty(S),
    % Prepended the state vector with one extra zero per channel
    S = nullstate1(Hd.filterquantizer);
else
    % Check data type, quantize if needed
    S = validatestates(Hd.filterquantizer, S);
    % Prepended the state vector with one extra zero per channel
    S = prependzero(Hd.filterquantizer, S);
end

% Reset tap index
Hd.TapIndex = 0;

% Store hidden states
Hd.HiddenStates = S;

% Don't duplicate
S = [];

