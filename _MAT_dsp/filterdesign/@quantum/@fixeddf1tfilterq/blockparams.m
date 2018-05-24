function p = blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

p = iir_blockparams(this,forceDigitalFilterBlock);

s = internalsettings(this);

if ~forceDigitalFilterBlock
  
  p.StateDataTypeStr = sprintf('fixdt(true,%d,%d)',s.StateWordLength, min(s.NumStateFracLength, s.DenStateFracLength));
  p.MultiplicandDataTypeStr = sprintf('fixdt(true,%d,%d)',s.MultiplicandWordLength, s.MultiplicandFracLength);
  
  if s.NumStateFracLength ~= s.DenStateFracLength
    warning(message('dsp:quantum:fixeddf1tfilterq:blockparams:cannotMap'));
  end
  
else
  
  p.memoryMode = 'Binary point scaling';
  p.memoryWordLength = sprintf('%d', s.StateWordLength);
  p.memoryFracLength = sprintf('%d', min(s.NumStateFracLength, s.DenStateFracLength));
  p.multiplicandMode = 'Binary point scaling';
  p.multiplicandWordLength = sprintf('%d', s.MultiplicandWordLength);
  p.multiplicandFracLength = sprintf('%d', s.MultiplicandFracLength);
  
  
  if s.NumStateFracLength ~= s.DenStateFracLength
    warning(message('dsp:quantum:fixeddf1tfilterq:blockparams:cannotMap'));
  end
    
end
