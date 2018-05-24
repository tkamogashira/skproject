function this = iirhalfbandeqripmin
%IIRHALFBANDEQRIPMIN   Construct an IIRHALFBANDEQRIPMIN object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.iirhalfbandeqripmin;

set(this, 'DesignAlgorithm', 'IIR quasi-linear phase');

% [EOF]
