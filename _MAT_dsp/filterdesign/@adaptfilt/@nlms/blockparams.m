function s = blockparams(Hd, mapstates, varargin)
%BLOCKPARAMS Returns the parameters for BLOCK

% Copyright 1999-2012 The MathWorks, Inc.

s = super_blockparams(Hd, mapstates);
s.Algo = 'Normalized LMS';

