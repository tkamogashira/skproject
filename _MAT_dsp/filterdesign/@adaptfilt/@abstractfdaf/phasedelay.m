function varargout = phasedelay(h, varargin)
%PHASEDELAY   Phase delay of a frequency domain adaptive filter. 

%   Author(s): P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:phasedelay:NotSupported', class( h )))

% [EOF]
