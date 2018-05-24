function b = actualdesign(this, hspecs, varargin)
%ACTUALDESIGN   Perform the design.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

N = get(hspecs, 'FilterOrder');

win = calculatewin(this, N);

if isempty(win)
    win = {hamming(N+1)};
end

b = {firhalfband(N, win{:})};

% [EOF]
