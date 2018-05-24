function productmode = set_productmode(q, productmode)
%SET_PRODUCTMODE   PreSet function for the 'ProductMode' property.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

q.privProductMode = productmode;

updateinternalsettings(q);

% [EOF]
