function p = blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

p = fir_blockparams(this,forceDigitalFilterBlock);

s = get(this);

if ~forceDigitalFilterBlock
  p.TapSumDataTypeStr = sprintf('fixdt(true,%d,%d)',s.TapSumWordLength,s.TapSumFracLength);  
else
  p.tapSumMode       = 'Binary point scaling';
  p.tapSumWordLength = sprintf('%d', s.TapSumWordLength);
  p.tapSumFracLength = sprintf('%d', s.TapSumFracLength);  
end