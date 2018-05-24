function lattice_thiscopy(this, Hd)
%LATTICE_THISCOPY   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

nonscalar_thiscopy(this, Hd);

set(this, ...
    'privstatewl', get(Hd, 'privstatewl'), ...
    'privstatefl', get(Hd, 'privstatefl'));

% [EOF]
