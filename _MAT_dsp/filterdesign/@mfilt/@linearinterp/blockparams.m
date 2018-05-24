function s = blockparams(Hd, mapstates, varargin)
%BLOCKPARAMS Returns the parameters for BLOCK

% Copyright 1999-2012 The MathWorks, Inc.

s = blockparams(Hd.filterquantizer);

s.h = mat2str(Hd.Numerator,18);
s.L = num2str(Hd.InterpolationFactor);

% IC
if strcmpi(mapstates, 'on'),
    [~, srcblk] = blocklib(Hd);
    error(message('dsp:mfilt:linearinterp:blockparams:mappingstates', srcblk));
end
