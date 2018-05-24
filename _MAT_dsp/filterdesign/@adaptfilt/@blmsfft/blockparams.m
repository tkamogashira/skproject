function s = blockparams(Hd, mapstates, varargin)
%BLOCKPARAMS Returns the parameters for BLOCK

% Copyright 1999-2012 The MathWorks, Inc.

t = Hd.FilterLength+Hd.BlockLength;
if t~=2^nextpow2(t),
    error(message('dsp:adaptfilt:blmsfft:blockparams:InvalidBlockLength'));
end
s = super_blockparams(Hd, mapstates);
s.Algo = 'Fast Block LMS';

