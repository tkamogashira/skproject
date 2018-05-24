function varargout = stepz(h, varargin)
%STEPZ   Step response of a frequency domain adaptive filter.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:stepz:NotSupported', class( h )))

% [EOF]
