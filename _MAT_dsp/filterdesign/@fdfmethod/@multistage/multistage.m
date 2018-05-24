function this = multistage
%MULTISTAGE   Construct a MULTISTAGE object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.multistage;

set(this, 'DesignAlgorithm', 'Multistage equiripple');

% [EOF]
