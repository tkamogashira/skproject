function determine_weights(this,wstruct)
%DETERMINE_WEIGHTS   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% For now, the weights are determined in a way necessary for Nyquist
% designs
nyquist_weights(this,wstruct);

% Since this is type II, the weights need to be modified accordingly
this.Wgrid = cos(this.fgrid*pi/2).*this.Wgrid;

% [EOF]
