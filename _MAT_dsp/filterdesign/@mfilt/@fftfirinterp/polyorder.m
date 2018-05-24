function np = polyorder(Hm)
%POLYORDER  Get the order of the polyphase filters.
%   This should be an abstract method.
  
%   Author: R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

np = ceil(Hm.ncoeffs/Hm.InterpolationFactor) - 1;
