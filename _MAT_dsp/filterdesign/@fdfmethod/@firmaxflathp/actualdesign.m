function varargout = actualdesign(this, hspecs, varargin)
%ACTUALDESIGN   Design the maximally flat highpass FIR filter

%   Copyright 2008 The MathWorks, Inc.

lspecs = copy(hspecs);
lspecs.F3dB = 1 - hspecs.F3dB;
lpargout = lpprototypedesign(this, lspecs, varargin{:});

% Highpass design
varargout = {{firlp2hp(lpargout{:})}};

% [EOF]
