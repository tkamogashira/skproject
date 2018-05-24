function s = blockparams(Hd, mapstates, varargin)
%BLOCKPARAMS Returns the parameters for BLOCK

% Copyright 1999-2012 The MathWorks, Inc.


s = blockparams(Hd.filterquantizer);
s.h = mat2str(Hd.Numerator,18);
R = Hd.RateChangeFactors;
s.L = num2str(R(1));
s.M = num2str(R(2));

% IC
if strcmpi(mapstates, 'on'),
    [~, srcblk] = blocklib(Hd);
    error(message('dsp:mfilt:firsrc:blockparams:mappingstates', srcblk));
end

