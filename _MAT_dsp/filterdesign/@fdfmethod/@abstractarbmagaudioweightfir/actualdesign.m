function coeffs = actualdesign(this,hspecs)
%ACTUALDESIGN   

%   Copyright 2009 The MathWorks, Inc.

setmaskspecs(hspecs);  
setfreqpoints(this,hspecs);          
[hspecsArbMag,fmethodArbMag] = getarbmagdesignobjects(this,hspecs);
coeffs = getcoeffs(this,hspecs,hspecsArbMag,fmethodArbMag);

% [EOF]
