function y = removelsbs(h,x,numofLSB)
%REMOVELSBS Remove LSBs while preserving MSBs.

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

% Trim numofLSB bits and keep the MSB
y = int32(floor(pow2(double(x),-numofLSB)));  % pow2(x,-numofLSB) = x*2^-numofLSB

% [EOF] $File: $
