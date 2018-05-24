function varargout = zerophase(h, varargin)
%ZEROPHASE   Zero-phase response of a frequency domain adaptive filter.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:zerophase:NotSupported', class( h )))

% [EOF]
