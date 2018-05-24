function accFL = keepmsbaccum(q, accinWL, accinFL, bits2add, accWL)
%KEEPMSBACCUM   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

if accWL<accinWL + bits2add,
    % Lose some LSBs
    intLength = accinWL + bits2add - accinFL;
    accFL = accWL - intLength; % No overflow
else
    accFL = accinFL;
end

% [EOF]
