function p = iir_blockparams(this,forceDigitalFilterBlock)
%IIR_BLOCKPARAMS   Block params for IIRs.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1 
  forceDigitalFilterBlock = false;
end

s = internalsettings(this);

if ~forceDigitalFilterBlock
  
  p = abstractfixed_discreteblockparams(this);
  
  p.NumAccumDataTypeStr = sprintf('fixdt(true,%d,%d)',s.AccumWordLength,s.NumAccumFracLength);
  p.DenAccumDataTypeStr = sprintf('fixdt(true,%d,%d)',s.AccumWordLength,s.DenAccumFracLength);
  
  p.NumProductDataTypeStr = sprintf('fixdt(true,%d,%d)',s.ProductWordLength,s.NumProdFracLength);
  p.DenProductDataTypeStr = sprintf('fixdt(true,%d,%d)',s.ProductWordLength,s.DenProdFracLength);
  
  p.NumCoefDataTypeStr = sprintf('fixdt(%s,%d,%d)','true', s.CoeffWordLength,s.NumFracLength);
  p.DenCoefDataTypeStr = sprintf('fixdt(%s,%d,%d)','true', s.CoeffWordLength,s.DenFracLength);
  
  if ~s.Signed
    warning(message('dsp:quantum:basecatalog:UnmappedCoeffSign'));
  end
  
else
  
  p = abstractfixed_blockparams(this);
  
  p.accumMode       = 'Binary point scaling';
  p.accumWordLength = sprintf('%d', s.AccumWordLength);
  p.accumFracLength = sprintf('%d', min(s.NumAccumFracLength, s.DenAccumFracLength));
  
  p.prodOutputMode       = 'Binary point scaling';
  p.prodOutputWordLength = sprintf('%d', s.ProductWordLength);
  p.prodOutputFracLength = sprintf('%d', min(s.NumProdFracLength, s.DenProdFracLength));
  
  p.firstCoeffMode       = 'Binary point scaling';
  p.firstCoeffWordLength = sprintf('%d', s.CoeffWordLength);
  p.firstCoeffFracLength = sprintf('%d', s.NumFracLength);
  
  p.secondCoeffFracLength = sprintf('%d', s.DenFracLength);
  
  if s.NumAccumFracLength ~= s.DenAccumFracLength
    warning(message('dsp:quantum:abstractfixediirfilterq:iir_blockparams:cannotMap1'));
  end
  
  if s.NumProdFracLength ~= s.DenProdFracLength
    warning(message('dsp:quantum:abstractfixediirfilterq:iir_blockparams:cannotMap2'));
  end
  
end