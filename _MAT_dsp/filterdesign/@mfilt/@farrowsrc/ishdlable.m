function [result, errstr, errorObj] = ishdlable(Hb)
%ISHDLABLE True if HDL can be generated for the filter object.
%   ISHDLABLE(Hd) determines if HDL code generation is supported for the
%   filter object Hd and returns true or false.
%
%   The determination is based on the filter structure and the 
%   arithmetic property of the filter.
%
%   The optional second return value is a string that specifies why HDL
%   could not be generated for the filter object Hd.
%
%   See also MFILT, GENERATEHDL.

%   Author(s): M. Chugh
%   Copyright 2005-2006 The MathWorks, Inc.

  switch lower(Hb.arithmetic)
   case {'double', 'fixed'}
    result = true;
    errstr = '';
    errorObj = [];
   otherwise
    result = false;
    errorObj = message('dsp:mfilt:farrowsrc:ishdlable:HdlNotSupportedArith',Hb.arithmetic);
    errstr = getString(errorObj);
    return;
  end
  
  %continue testing
  if ~isposinteger(Hb.InterpolationFactor) || ~isposinteger(Hb.DecimationFactor)
    result = false;
    errorObj = message('dsp:mfilt:farrowsrc:ishdlable:HdlNotSupportedInterpDecim');
    errstr = getString(errorObj);    
  end

function success = isposinteger(value)

success = false;
if (floor(value) == value) && value > 0 % +ve and integer
    success = true;
end

% [EOF]