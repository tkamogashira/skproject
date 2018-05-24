function productmode = set_productmode(this, productmode)
%SET_PRODUCTMODE   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

this.privProductMode = productmode;

% Update fimath 
this.fimath.ProductMode = productmode;

updateinternalsettings(this);

% [EOF]
