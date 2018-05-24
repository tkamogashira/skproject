function this = iirlinphasehilbertmin
%IIRLINPHASEHILBERTMIN   Construct an IIRLINPHASEHILBERTMIN object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.iirlinphasehilbertmin;

this.DesignAlgorithm = 'IIR quasi-linear phase';

% [EOF]
