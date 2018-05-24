function value = setbps(h,value)
%SETBPS SetFunction for the BitsPerStage property.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

% If a vector was specified for the BitsPerStage property, it must be
% monotonically increasing.
if length(value) > 1,
    if any(diff(value)<0),
        error(message('dsp:mfilt:abstractcicinterp:setbps:MFILTErr'));
    end
end

% [EOF]
