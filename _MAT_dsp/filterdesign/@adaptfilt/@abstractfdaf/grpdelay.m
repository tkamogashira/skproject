function varargout = grpdelay(this, varargin)
%GRPDELAY   Errors out.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

error(message('dsp:adaptfilt:abstractfdaf:grpdelay:NotSupported', class( this )))

% [EOF]
