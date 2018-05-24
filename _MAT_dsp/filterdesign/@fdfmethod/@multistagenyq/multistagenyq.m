function this = multistagenyq
%MULTISTAGENYQ   Construct a MULTISTAGENYQ object.

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

this = fdfmethod.multistagenyq;

set(this, 'DesignAlgorithm', 'Multistage equiripple');

% [EOF]
