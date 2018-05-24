function p = blockparams(this, varargin)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

p = sos2_blockparams(this);

p.memoryFracLength = sprintf('%d', this.StateFracLength);
