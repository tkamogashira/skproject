function thisreset(Hm)
%THISRESET Reset the private "memory" of the firfracdecim filter.

% This should be a private method - do not use!

%   Author: P. Pacheco
%   Copyright 1999-2004 The MathWorks, Inc.


% This function is called when the firfracdecim constructor sets L and M.
% So, this is a good place to set initial index values.

% Get rate change factors and euclid factors.
R = Hm.RateChangeFactor;
L = R(1);  M = R(2);
Pdelays = Hm.PolyphaseDelays;
l0 = Pdelays(1); m0 = Pdelays(2);

Lh = ceil(Hm.nCoeffs/(L*M));     % Length of polyphase sub-filter.
inDelays = (L-1)*l0 + M*(Lh-1);  % Input + filter states.
if isempty(Lh), return, end  % Initializing object.

%%%% Reset the properties that represent state information. %%%%

% Set the indices for the input delay line of each interp phase.
for n = 1:L,
    l0delays = (L-n)*l0;
    Hm.inBufIdx(n) = inDelays-l0delays;
end

% Input delay line "write" index.  Start at the bottom of input buffer.
Hm.inBufWIdx   = inDelays;
Hm.InputOffset = 0;    % Must be zero!
Hm.outBufIdx   = 1;  

Hm.PolyphaseAccum = zeros(L,1); 

% [EOF]
