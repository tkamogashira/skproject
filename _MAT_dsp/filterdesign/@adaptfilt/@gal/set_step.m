function s = set_step(h,s)
%SET_STEP Set the Step size.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

if s < 0 | s > 1,
    error(message('dsp:adaptfilt:gal:set_step:InvalidRange'));
end

