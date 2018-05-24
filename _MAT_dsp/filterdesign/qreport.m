function s = qreport(F)
%QREPORT  Quantized report.
%   QREPORT(F) displays a report of the minimum, maximum, number of
%   overflows number of underflows, and number of operations of the most
%   recent application of F, where F is a quantized FFT object or a quantizer
%   object.
%
%   If WARNING is ON, then this report is displayed whenever a quantizer or
%   a quantized FFT overflows.
%
%   S = QREPORT(F) returns a MATLAB structure containing the information,
%   and QREPORT(F) displays the report.  MATLAB structure S contains the
%   following fields:
%
%     S.coefficient
%      .input
%      .output
%      .multiplicand
%      .product
%      .sum
%   and each subfield contains:
%                  .max
%                  .min
%                  .nover
%                  .nunder
%                  .noperations
%   For coefficient, multiplicand, product, and sum, the subfields can be indexed
%   into like this:
%     S.coefficient(1:N).max
%     S.coefficient(1:N).min
%     etc.
%
%   Fields S.input and S.output only contain one element.
%
%   Examples:
%       w = warning('on');
%       F = qfft('length',64,'scale',1/64);
%       Y = fft(F,randn(64,1));
%       qreport(F)
%       warning(w);
%
%  
%   See also QFFT/QFFT, QUANTIZER/QUANTIZER.

%   Thomas A. Bryan, 31 August 1999
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(1,1,nargin,'struct'));
error(nargoutchk(0,1,nargout,'struct'));
switch(class(F))
  case 'qfft'
    if nargout
      s = qfftreport(F);
    else
      qfftreport(F);
    end
  otherwise
    error(message('dsp:qreport:FixedPtErr', class( F )));
end
