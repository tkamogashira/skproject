function setsysobjfixedpoint(this,Hs)
%SETSYSOBJFIXEDPOINT Set converted System object fixed point properties

%   Copyright 2011 The MathWorks, Inc.

  if ~this.CastBeforeSum
    warning(message('dsp:quantum:basecatalog:InvalidCastBeforeSum',class(this),class(Hs)))
  end
  if ~this.Signed
    warning(message('dsp:quantum:basecatalog:InvalidUnsignedArithmetic','DFILT',class(Hs)));
  end
    
  Hs.NumeratorCoefficientsDataType = 'Custom';
  Hs.CustomNumeratorCoefficientsDataType = ...
    numerictype([],this.CoeffWordLength,this.NumFracLength);
  Hs.DenominatorCoefficientsDataType = 'Custom';
  Hs.CustomDenominatorCoefficientsDataType = ...
    numerictype([],this.CoeffWordLength, this.DenFracLength);
  
  Hs.ScaleValuesDataType = 'Custom';
  Hs.CustomScaleValuesDataType = ...
    numerictype([],this.CoeffWordLength,this.ScaleValueFracLength);
  
  Hs.NumeratorProductDataType = 'Custom';
  Hs.CustomNumeratorProductDataType = ...
    numerictype([],this.ProductWordLength, this.NumProdFracLength);
  Hs.DenominatorProductDataType = 'Custom';
  Hs.CustomDenominatorProductDataType = ...
    numerictype([],this.ProductWordLength, this.DenProdFracLength);
  
  Hs.NumeratorAccumulatorDataType = 'Custom';
  Hs.CustomNumeratorAccumulatorDataType = ...
    numerictype([],this.AccumWordLength, this.NumAccumFracLength);
  Hs.DenominatorAccumulatorDataType = 'Custom';
  Hs.CustomDenominatorAccumulatorDataType = ...
    numerictype([],this.AccumWordLength, this.DenAccumFracLength);
  
  Hs.OutputDataType = 'Custom';
  Hs.CustomOutputDataType = ...
    numerictype([],this.OutputWordLength,this.OutputFracLength);
  
  Hs.RoundingMethod = maproundmode(this);
  Hs.OverflowAction = this.OverflowMode;
  
  % Let the subclass set the rest of the System object fixed-point
  % properties
  this_setsysobjfixedpoint(this,Hs);
  
  % [EOF]
