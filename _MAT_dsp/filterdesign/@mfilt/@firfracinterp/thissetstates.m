function S = thissetstates(Hm,S)
%THISSETSTATES Overloaded set for the States property.

% This should be a private method

%   Author: A. Charry
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactors;
L = R(1); M = R(2);


P = Hm.PolyphaseDelays;
if isempty(P),
    m0 = 1;
else
    m0 = P(1);
end
outBufSize = m0*(M-1);
filtBufSize = nstates(Hm)-outBufSize;


if isempty(S),
    % Prepend one extra zero per channel to the input buffer
    S = zeros(nstates(Hm)+2,1);
else
    [dummy nchan] = size(S);
    
    % Prepended one extra zero per channel
    filtBuf = [zeros(1,nchan); S(1:filtBufSize,:)];
    
    % Prepended one extra zero per channel to the output buffer
    outBuf = [zeros(1,nchan); S(filtBufSize+1:filtBufSize+outBufSize,:)];
    
    S = [filtBuf;outBuf];
end

% Reset circular buffer index;
Hm.TapIndex = 0;

% Store hidden states
Hm.HiddenStates = S;

% Don't duplicate
S = [];
