function n = thisnpolyphase(this)
%THISNPOLYPHASE   Return the number of polyphases.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

n = max(this.RateChangeFactors);

% [EOF]
