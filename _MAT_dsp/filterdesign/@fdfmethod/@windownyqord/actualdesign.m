function b = actualdesign(this, hspecs, varargin)
%ACTUALDESIGN   

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

N = get(hspecs, 'FilterOrder');

win = calculatewin(this, N, varargin{:});

b = {firnyquist(N, get(hspecs, 'Band'), win{:})};

% [EOF]
