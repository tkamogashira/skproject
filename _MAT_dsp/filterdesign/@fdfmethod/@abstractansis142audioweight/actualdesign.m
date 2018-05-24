function coeffs = actualdesign(this,hspecs)
%ACTUALDESIGN   

%   Copyright 2009 The MathWorks, Inc.

% Set the mask on the hspecs object
setmaskspecs(hspecs);  
Fs = hspecs.ActualDesignFs;

% Get zeros and poles as specified by ANSI S1.42 standard
[zW,pW,kW] = getzeropoles(this);

% Convert analog zeros and poles to a digital transfer function using the
% bilinear transformation
[z,p,k] = bilinear(zW,pW,kW,Fs);
[s,g] = zp2sos(z,p,k);
    
coeffs = {s,g};

% [EOF]
