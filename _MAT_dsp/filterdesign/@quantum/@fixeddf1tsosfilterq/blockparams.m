function p = blockparams(this, varargin)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

p = sos2_blockparams(this);

s = internalsettings(this);

p.multiplicandMode = 'Binary point scaling';
p.multiplicandWordLength = sprintf('%d', s.MultiplicandWordLength);
p.multiplicandFracLength = sprintf('%d', s.MultiplicandFracLength);

p.memoryFracLength = sprintf('%d', s.NumStateFracLength);
p.secondMemoryFracLength = sprintf('%d', s.DenStateFracLength);
