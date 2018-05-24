function varargout = impz(h, varargin)
%IMPZ   Impulse response of a frequency domain adaptive filter.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:impz:NotSupported', class( h )))

% [EOF]
