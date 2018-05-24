function [msgObj,value] = scalevaluescheck(F,value)
%SCALEVALUESCHECK Check the scale values for QFFT object.
%   [MSG,S] = SCALEVALUESCHECK(F,S) checks that the value of S is
%   appropriate for the F.scalevalues property where F is a QFFT
%   object.  If it is wrong, then an appropriate error message is
%   returned in string MSG.  If it is right, then MSG is empty.  S must
%   be numeric and a scalar, or a vector of length F.numberofsections.
%   If no error, then S is returned with the correct scale value.  This
%   allows for expanding empty scale values.

%   Thomas A. Bryan
%   Copyright 1999-2011 The MathWorks, Inc.

msgObj = [];
if nargin<2
  value = get(F,'scalevalues');
end
if isempty(value)
  value = 1;
end
if ~isnumeric(value)
  msgObj = message('dsp:scalevaluescheck:invalidScaleValues1');
  return
end
if ~isreal(value)
  msgObj = message('dsp:scalevaluescheck:invalidScaleValues2');
  return
end
value = value(:)';
