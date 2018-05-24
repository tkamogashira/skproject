function p = blockparams(this, varargin)
%BLOCKPARAMS   Returns the parameters for the block.

%   Copyright 1999-2012 The MathWorks, Inc.

% Get the generic fixed point params, like "product" & "sum" settings.
p = fir_blockparams(this);

s = internalsettings(this);

p.memoryMode       = 'Binary point scaling';
p.memoryWordLength = sprintf('%d', s.StateWordLength);
p.memoryFracLength = sprintf('%d', s.StateFracLength);
