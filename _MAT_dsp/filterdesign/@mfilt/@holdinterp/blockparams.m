function s = blockparams(Hd, mapstates, varargin)
%BLOCKPARAMS Returns the parameters for BLOCK

% Copyright 1999-2012 The MathWorks, Inc.


s.N = num2str(Hd.InterpolationFactor);

% IC
if strcmpi(mapstates, 'on'),
    [~, srcblk] = blocklib(Hd);
    error(message('dsp:mfilt:holdinterp:blockparams:mappingstates', srcblk));
end
