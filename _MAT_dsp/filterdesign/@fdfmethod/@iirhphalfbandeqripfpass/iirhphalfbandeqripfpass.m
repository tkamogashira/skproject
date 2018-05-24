function this = iirhphalfbandeqripfpass
%IIRHPHALFBANDEQRIPFPASS Construct an IIRHPHALFBANDEQRIPFPASS object
%   OUT = IIRHPHALFBANDEQRIPFPASS(ARGS) <long description>

%   Copyright 2007 The MathWorks, Inc.

this = fdfmethod.iirhphalfbandeqripfpass;
set(this, 'DesignAlgorithm', 'IIR quasi-linear phase');

% [EOF]
