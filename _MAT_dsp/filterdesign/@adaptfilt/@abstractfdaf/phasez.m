function varargout = phasez(h, varargin)
%PHASEZ   Phase response of a frequency domain adaptive filter.

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:phasez:NotSupported', class( h )))

% [EOF]
