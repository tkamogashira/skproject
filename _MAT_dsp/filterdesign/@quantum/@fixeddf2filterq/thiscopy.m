function thiscopy(this, Hd)
%THISCOPY   Copy this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

iir_thiscopy(this, Hd);

set(this, ...
    'privstatewl', Hd.privstatewl, ...
    'privstatefl', Hd.privstatefl);

% [EOF]
