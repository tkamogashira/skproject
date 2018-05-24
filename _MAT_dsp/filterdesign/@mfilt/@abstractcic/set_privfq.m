function privfq = set_privfq(this, privfq)
%SET_PRIVFQ   PreSet function for the 'privfq' property.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

l  = [handle.listener(privfq, 'updateinternals', @(x,y)updatefilterinternals(this)); ...
    handle.listener(privfq, 'quantizestates', @(x, y)quantizestates(this))];

set(this, 'filterquantizerlisteners', l);


% [EOF]
