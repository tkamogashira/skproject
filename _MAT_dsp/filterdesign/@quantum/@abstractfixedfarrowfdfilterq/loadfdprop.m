function loadfdprop(this,s)
%LOADFDPROP <short description>
%   OUT = LOADFDPROP(ARGS) <long description>

%   Copyright 2007 The MathWorks, Inc.

this.FDWordLength = s.FDWordLength;
this.FDAutoScale  = false;
this.FDFracLength = s.FDFracLength;
this.FDAutoScale  = s.FDAutoScale;

% [EOF]
