function varargout = freqz(h, varargin)
%FREQZ   Frequency response of a frequency domain adaptive filter.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:freqz:NotSupported', class( h )))

% [EOF]
