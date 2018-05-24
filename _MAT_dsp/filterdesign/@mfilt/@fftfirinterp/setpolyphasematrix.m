function polym = setpolyphasematrix(this, polym)
%SETPOLYPHASEMATRIX   Set the polyphasematrix.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% Check data type and store polyphase matrix as reference
set(this, 'refpolym', polym); 

% Get filter order
M = polyorder(this);

% Get block length
BL = this.BlockLength;

% Set the fft coeffs as columns
this.fftcoeffs = fft(polym.',BL+M);

% Quantize the coefficients
% quantizecoeffs(this);

% Hold an empty to not duplicate storage
polym = [];

% [EOF]
