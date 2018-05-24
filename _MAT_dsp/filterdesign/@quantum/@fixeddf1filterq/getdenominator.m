function den = getdenominator(Hd, den)
%GETDENOMINATOR 
  
%   Copyright 1999-2003 The MathWorks, Inc.

den = double(den);

% Substitute a0 coefficient as an exact 1
den(1) = 1;
