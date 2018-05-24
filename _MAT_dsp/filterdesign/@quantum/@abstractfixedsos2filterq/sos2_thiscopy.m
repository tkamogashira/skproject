function sos2_thiscopy(this, Hd)
%SOS2_THISCOPY   Copy the SOS2 properties.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

sos_thiscopy(this, Hd);

set(this, ...
    'privstatewl', Hd.privstatewl, ...
    'privstatefl', Hd.privstatefl, ...
    'privstageinwl', Hd.privstageinwl, ...
    'privstageinfl', Hd.privstageinfl, ...
    'privstageoutwl', Hd.privstageoutwl, ...
    'privstageoutfl', Hd.privstageoutfl);

% Let the subclasses set the fraction lengths because they might have
% autoscale properties.

% [EOF]
