function [msgObj] = lengthcheck(F,value)
%LENGTHCHECK  Check length of QFFT.
%   MSG = LENGTHCHECK(F) checks that F.length is an appropriate value for the
%   length property where F is a QFFT object.
%
%   MSG = LENGTHCHECK(F,L) checks that length L is an appropriate value for the
%   F.length property where F is a QFFT object.  
%
%   The length must be a power of the radix.  If the length is wrong, then an
%   appropriate error message is returned in MSG.  If the length is right, then
%   MSG is empty.

%   Thomas A. Bryan
%   Copyright 1999-2011 The MathWorks, Inc.

if nargin<2
  value = F.length;
end
msgObj = []; 
if ~isnumeric(value)
  msgObj = message('dsp:lengthcheck:MustBeNumeric'); 
  return;
end
if prod(size(value))~=1
  msgObj = message('dsp:lengthcheck:InvalidDimensions'); 
  return;
end
if value<1
  msgObj = message('dsp:lengthcheck:MustBePositive'); 
  return;
end
if floor(value)~=value
  msgObj = message('dsp:lengthcheck:MustBeInteger'); 
  return;
end
base = F.radix;
L = log2(value)/log2(base);
if L ~= floor(L)
  msgObj = message('dsp:lengthcheck:invalidLength', num2str(base));
  return;
end
