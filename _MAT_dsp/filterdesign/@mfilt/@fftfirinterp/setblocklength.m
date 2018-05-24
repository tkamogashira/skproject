function BL = setblocklength(Hm, BL)
%SETBLOCKLENGTH Overloaded set on the blocklength property.
  
%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

% Get polyphase matrix
P = polyphase(Hm);

% Get filter order
M = polyorder(Hm);

% Set the fft coeffs as columns
Hm.fftcoeffs = fft(P.',BL+M); 

