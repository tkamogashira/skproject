function p = fir_blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Return the block params for the fixed point settings.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

s = get(this);

if ~forceDigitalFilterBlock
  
  p = abstractfixed_discreteblockparams(this);
  
  p.AccumDataTypeStr = sprintf('fixdt(true,%d,%d)',s.AccumWordLength,s.AccumFracLength);
  p.ProductDataTypeStr = sprintf('fixdt(true,%d,%d)',s.ProductWordLength,s.ProductFracLength);
  if s.Signed
    signedness = 'true';
  else
    signedness = 'false';
  end
  p.CoefDataTypeStr = sprintf('fixdt(%s,%d,%d)',signedness,s.CoeffWordLength,s.NumFracLength);
  
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
  p.firstCoeffFracLength = sprintf('%d', s.NumFracLength);
  
end