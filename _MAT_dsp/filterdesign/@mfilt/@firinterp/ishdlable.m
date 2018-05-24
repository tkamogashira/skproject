function [result, errstr, errorObj] = ishdlable(filterobj)
%ISHDLABLE True if HDL can be generated for the filter object.
%   ISHDLABLE(Hm) determines if HDL code generation is supported for the
%   multirate filter object Hm and returns 1 if true and 0 if false.
%
%   The determination is based solely on the FILTERSTRUCTURE property of
%   the quantized filter.
%
%   The optional second return value is a string that specifies why HDL
%   could not be generated for the filter object Hm.
%
%   See also MFILT/GENERATEHDL.

%   Copyright 2004 The MathWorks, Inc.

  switch lower(filterobj.arithmetic)
   case {'double', 'fixed'}
    result = true;
    errstr = '';
    errorObj = [];
   otherwise
    result = false;
    errorObj = message('dsp:mfilt:firinterp:ishdlable:HdlNotSupportedArith',filterobj.arithmetic);
    errstr = getString(errorObj);
  end
  firlen = length(filterobj.numerator);
  if firlen == 1                        % zero order case
    result = false;
    errorObj = message('dsp:mfilt:firinterp:ishdlable:HdlNotSupportedZeroOrder');
    errstr = getString(errorObj);
  end
% [EOF]

