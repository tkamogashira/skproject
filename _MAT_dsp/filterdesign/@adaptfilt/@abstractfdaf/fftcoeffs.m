function c = fftcoeffs(Hd)
%FFTCOEFFS  FFT coefficients.
%   C = FFTCOEFFS(Hd) returns the frequency-domain coefficients used when
%   filtering. 
% 
%   NOTE: FFTCOEFFS is available for the following adaptive filters:
%    ADAPTFILT.FDAF
%    ADAPTFILT.UFDAF
%    ADAPTFILT.PBFDAF
%    ADAPTFILT.PBUFDAF
%
%   See also ADAPTFILT/INFO.
  
%   Author(s): P. Costa
%   Copyright 2004 The MathWorks, Inc.

c = Hd.FFTCoefficients;

% [EOF]
