function this = iirlinphasehilbertfpass
%IIRLINPHASEHILBERTFPASS   Construct an IIRLINPHASEHILBERTFPASS object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.iirlinphasehilbertfpass;


this.DesignAlgorithm = 'IIR quasi-linear phase';
this.FilterStructure = 'cascadeallpass';

% [EOF]
