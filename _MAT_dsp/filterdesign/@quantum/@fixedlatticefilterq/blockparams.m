function p = blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Return the block parameters.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

s = internalsettings(this);

if ~forceDigitalFilterBlock
  
  p = abstractfixed_discreteblockparams(this);
  
  p.AccumDataTypeStr = sprintf('fixdt(true,%d,%d)',s.AccumWordLength,s.AccumFracLength);
  p.ProductDataTypeStr = sprintf('fixdt(true,%d,%d)',s.ProductWordLength,s.ProductFracLength);
  p.StateDataTypeStr = sprintf('fixdt(true,%d,%d)',s.StateWordLength,s.StateFracLength);
  
  if s.Signed
    signedness = 'true';
  else
    signedness = 'false';
  end
  p.CoefDataTypeStr = sprintf('fixdt(%s,%d,%d)',signedness,s.CoeffWordLength,s.LatticeFracLength);
  
else
  
  p = abstractfixed_blockparams(this);
  
  p.accumMode       = 'Binary point scaling';
  p.accumWordLength = sprintf('%d', s.AccumWordLength);
  p.accumFracLength = sprintf('%d', s.AccumFracLength);
  
  p.prodOutputMode       = 'Binary point scaling';
  p.prodOutputWordLength = sprintf('%d', s.ProductWordLength);
  p.prodOutputFracLength = sprintf('%d', s.ProductFracLength);
  
  p.firstCoeffMode       = 'Binary point scaling';
  p.firstCoeffWordLength = sprintf('%d', s.CoeffWordLength);
  p.firstCoeffFracLength = sprintf('%d', s.LatticeFracLength);
  
  p.memoryMode       = 'Binary point scaling';
  p.memoryWordLength = sprintf('%d', s.StateWordLength);
  p.memoryFracLength = sprintf('%d', s.StateFracLength);
  
end
