function n = thisimpzlength(this)
%THISIMPZLENGTH   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% Dispatch to get the upsampled filter.  The impzlength should be based off
% of this filter.
Hd = dispatch(this);
n  = impzlength(Hd);

% [EOF]
