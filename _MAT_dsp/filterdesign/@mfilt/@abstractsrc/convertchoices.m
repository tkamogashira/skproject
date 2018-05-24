function [targs, strs] = convertchoices(this)
%CONVERTCHOICES   Return the convert targets.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

targs = 'firsrc';
strs  = 'Direct-Form FIR Polyphase Sample-Rate Converter';

if this.RateChangeFactors(1) > this.RateChangeFactors(2)
    targs = {targs};
    strs  = {strs, 'Direct-Form FIR Polyphase Fractional Interpolator'};
else
    targs = {'firsrc'};
    strs  = {strs, 'Direct-Form FIR Polyphase Fractional Decimator'};
end

% If this is a pure decimator, allow conversion to the simple decimators.
if this.RateChangeFactors(1) == 1
    targs = {targs{:}, 'firdecim', 'firtdecim'};
    strs  = {strs{:}, 'Direct-Form FIR Polyphase Decimator', ...
        'Direct-Form FIR Transposed Polyphase Decimator'};
end

% If this is a pure interpolator, allow conversion to the simple interpolators.
if this.RateChangeFactors(2) == 1
    targs = {targs{:}, 'firinterp', 'fftfirinterp'};
    strs  = {strs{:}, 'Direct-Form FIR Polyphase Interpolator', ...
        'Overlap-Add FIR Polyphase Interpolator'};
end

% [EOF]
