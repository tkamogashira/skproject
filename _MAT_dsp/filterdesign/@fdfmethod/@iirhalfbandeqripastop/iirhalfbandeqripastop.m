function this = iirhalfbandeqripastop
%IIRHALFBANDEQRIPASTOP   Construct an IIRHALFBANDEQRIPASTOP object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.iirhalfbandeqripastop;

set(this, 'DesignAlgorithm', 'IIR quasi-linear phase');

% [EOF]
