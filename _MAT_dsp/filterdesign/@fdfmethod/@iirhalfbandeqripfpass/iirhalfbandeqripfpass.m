function this = iirhalfbandeqripfpass
%IIRHALFBANDEQRIPFPASS   Construct an IIRHALFBANDEQRIPFPASS object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.iirhalfbandeqripfpass;

set(this, 'DesignAlgorithm', 'IIR quasi-linear phase');

% [EOF]
