function [mmse,emse,meanW,mse,traceK] = msepred(h,x,d,M);
%MSEPRED Predicted mean-squared error.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

error(nargchk(3,4,nargin,'struct'));

error(message('dsp:adaptfilt:adjfxlms:msepred:NotSupported'));
