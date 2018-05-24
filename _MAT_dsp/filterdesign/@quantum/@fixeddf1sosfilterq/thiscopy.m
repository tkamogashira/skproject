function thiscopy(this, Hd)
%THISCOPY   Copy the properties at this level.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

sos_thiscopy(this, Hd);

set(this, ...
    'privnstatewl', Hd.privnstatewl, ...
    'privdstatewl', Hd.privdstatewl, ...
    'privnstatefl', Hd.privnstatefl, ...
    'privdstatefl', Hd.privdstatefl);

% [EOF]
