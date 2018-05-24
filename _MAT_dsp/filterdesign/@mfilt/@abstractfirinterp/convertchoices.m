function [targs, strs] = convertchoices(this)
%CONVERTCHOICES   Return the convert targets.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

targs = {'firinterp', 'fftfirinterp'};
strs  = {'Direct-Form FIR Polyphase Interpolator', ...
    'Overlap-Add FIR Polyphase Interpolator'};

% [EOF]
