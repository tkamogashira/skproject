function dtRows = dspblkGetConvolutionDTRowInfo()
%dspblkGetConvolutionDTRowInfo
%
%  DSP System Toolbox library block mask helper function
%  used by the Convolution block.

% Copyright 2009 The MathWorks, Inc.

dtRows = dspblkGetCorrelationDTRowInfo();
% [EOF]
