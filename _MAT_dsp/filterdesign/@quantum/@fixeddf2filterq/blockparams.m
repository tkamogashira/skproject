function p = blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Return the parameters

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

p = iir_blockparams(this,forceDigitalFilterBlock);

s = internalsettings(this);

if ~forceDigitalFilterBlock
  
  p.StateDataTypeStr = sprintf('fixdt(true,%d,%d)',s.StateWordLength,s.StateFracLength);
  
else
  
  p.memoryMode       = 'Binary point scaling';
  p.memoryWordLength = sprintf('%d', s.StateWordLength);
  p.memoryFracLength = sprintf('%d', s.StateFracLength);
  
end
