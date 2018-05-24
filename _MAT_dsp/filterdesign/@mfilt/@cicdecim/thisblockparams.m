function p = thisblockparams(this)
%THISBLOCKPARAMS   Return the block params.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.


p.R   = sprintf('%d', get(this, 'DecimationFactor'));



% [EOF]
