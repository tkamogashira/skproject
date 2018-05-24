function privfq = set_privfq(this, privfq)
%SET_PRIVFQ   PreSet function for the 'privfq' property.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% Add a listener to the quantizecoeffs event
l = [handle.listener(privfq, 'quantizecoeffs', @super_quantizecoeffs); ...
    handle.listener(privfq, 'quantizestates', @quantizestates); ...
    handle.listener(privfq, 'quantizeacc', @quantizeacc)];
set(l,'callbacktarget',this);

% Store listener
set(this, 'filterquantizerlisteners', l);

% [EOF]
