function p = blockparams(this, varargin)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

p = fir_blockparams(this);

s = internalsettings(this);

p.tapSumFracLength = sprintf('%d', s.TapSumFracLength);

