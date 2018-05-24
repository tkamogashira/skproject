function c = fftcoeffs(Hm)
%FFTCOEFFS  Get the FFT coefficients used for the filtering.
%   C = FFTCOEFFS(Hd) returns the frequency-domain polyphase coefficient
%   matrix  used in the filtering. These coefficients are computed and
%   stored prior to filtering.
  
%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

% Return as a row
c = Hm.fftcoeffs.';
