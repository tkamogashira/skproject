function S = getstates(Hm,dummy)
%GETSTATES Overloaded get for the States property.

% This should be a private method

%   Author: A. Charry
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactors;
L = R(1); M = R(2);
Pdelays = Hm.PolyphaseDelays;
l0 = Pdelays(2);
m0 = Pdelays(1);

S = Hm.HiddenStates; % Input and output buffer.
nchan = size(S,2);

% Output buffer
outBufSize = (M-1)*m0+1;
outBuf = S(end-outBufSize+2:end,:); % Remove extra state

% Filter buffer
S(end-outBufSize+1:end,:) = [];
% Circular -> Linear
tapIndex = Hm.TapIndex+1; %1-based indexing
filtBuf = S;
filtBuf = [S(tapIndex+1:end,:); S(1:tapIndex-1,:)]; % Remove extra state

S = [filtBuf;outBuf];

% [EOF]

