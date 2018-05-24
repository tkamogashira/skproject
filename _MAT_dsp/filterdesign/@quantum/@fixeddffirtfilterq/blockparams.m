function p = blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Returns the parameters for the block.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

p = fir_blockparams(this,forceDigitalFilterBlock);

s = get(this);

if ~forceDigitalFilterBlock
  p.StateDataTypeStr = sprintf('fixdt(true,%d,%d)',s.StateWordLength,s.StateFracLength);
else
  p.memoryMode       = 'Binary point scaling';
  p.memoryWordLength = sprintf('%d', s.StateWordLength);
  p.memoryFracLength = sprintf('%d', s.StateFracLength);
end
