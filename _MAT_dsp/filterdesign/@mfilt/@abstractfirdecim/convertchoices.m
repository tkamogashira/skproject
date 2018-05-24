function [targs, strs] = convertchoices(this)
%CONVERTCHOICES   Returns the convert choices.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

targs = {'firdecim', 'firtdecim'};
strs = {'Direct-Form FIR Polyphase Decimator', ...
    'Direct-Form Transposed FIR Polyphase Decimator'};

% [EOF]
