function setsysobjfixedpoint(this,Hs)
%SETSYSOBJFIXEDPOINT Set converted System object fixed point properties

%   Copyright 2011 The MathWorks, Inc.

propList = {'CustomCoefficientsDataType','CustomProductDataType',...
  'CustomAccumulatorDataType','CustomOutputDataType'};
for idx = 1:length(propList)
  fixedPointAttributes = getFixedPointRestrictions(Hs,propList{1});
  signedness.(propList{idx}) = fixedPointAttributes{1};
end

if ~any(strcmpi({'unsigned','specsigned'},signedness.CustomCoefficientsDataType)) && ~this.Signed
  warning(message('dsp:quantum:basecatalog:InvalidUnsignedArithmetic','DFILT/MFILT',class(Hs)));
end

Hs.CoefficientsDataType = 'Custom';
sgn = getSignedness(...
  this,signedness.CustomCoefficientsDataType,'CustomCoefficientsDataType');
Hs.CustomCoefficientsDataType = ...
  numerictype(sgn, this.CoeffWordLength, this.NumFracLength);

if strcmpi(this.FilterInternals,'SpecifyPrecision')
  Hs.FullPrecisionOverride = false;
    
  Hs.ProductDataType = 'Custom';
  sgn = getSignedness(...
    this,signedness.CustomProductDataType,'CustomProductDataType');
  Hs.CustomProductDataType = ...
    numerictype(sgn, this.ProductWordLength, this.ProductFracLength);
  
  Hs.AccumulatorDataType = 'Custom';
  sgn = getSignedness(...
    this,signedness.CustomAccumulatorDataType,'CustomAccumulatorDataType');
  Hs.CustomAccumulatorDataType = ...
    numerictype(sgn, this.AccumWordLength, this.AccumFracLength);
  
  Hs.OutputDataType = 'Custom'; 
  sgn = getSignedness(...
    this,signedness.CustomOutputDataType,'CustomOutputDataType');
  Hs.CustomOutputDataType = ...
    numerictype(sgn, this.OutputWordLength, this.OutputFracLength);
  
  Hs.RoundingMethod = maproundmode(this);
  Hs.OverflowAction = this.OverflowMode;  
end  

function s = getSignedness(this,signAttribute,propName)

switch lower(signAttribute)
  case 'autosigned'
    s = [];
  case 'signed'
    s = true;
  case 'unsigned'
    s = false;
  case 'specsigned'
    if strcmp(propName,'CustomCoefficientsDataType')
      s = this.Signed;
    else
      s = true;
    end
end

  