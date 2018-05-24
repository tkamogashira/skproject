function setsysobjfixedpoint(this,Hs)
%SETSYSOBJFIXEDPOINT Set converted System object fixed point properties

%   Copyright 2012 The MathWorks, Inc.

  if ~this.CastBeforeSum
    warning(message('dsp:quantum:basecatalog:InvalidCastBeforeSum','DFILT',class(Hs)))
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
    
  if ~strcmp(this.ProductMode,'FullPrecision')  
    Hs.NumeratorProductDataType = 'Custom';
    Hs.CustomNumeratorProductDataType = ...
      numerictype([],this.ProductWordLength, this.NumProdFracLength);
    Hs.DenominatorProductDataType = 'Custom';
    Hs.CustomDenominatorProductDataType = ...
      numerictype([],this.ProductWordLength, this.DenProdFracLength);
  end
  
  if ~strcmp(this.AccumMode,'FullPrecision')
    Hs.NumeratorAccumulatorDataType = 'Custom';
    Hs.CustomNumeratorAccumulatorDataType = ...
      numerictype([],this.AccumWordLength, this.NumAccumFracLength);
    Hs.DenominatorAccumulatorDataType = 'Custom';
    Hs.CustomDenominatorAccumulatorDataType = ...
      numerictype([],this.AccumWordLength, this.DenAccumFracLength);
  end
  
  Hs.OutputDataType = 'Custom';
  Hs.CustomOutputDataType = ...
    numerictype([],this.OutputWordLength,this.OutputFracLength);
  
  Hs.RoundingMethod = maproundmode(this);
  Hs.OverflowAction = this.OverflowMode;
  
  Hs.StateDataType = 'Custom';
  Hs.CustomStateDataType = ...
   numerictype([],this.StateWordLength,this.StateFracLength);
  
  
  
    