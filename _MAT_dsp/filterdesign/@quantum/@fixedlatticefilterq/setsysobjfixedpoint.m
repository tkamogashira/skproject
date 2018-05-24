function setsysobjfixedpoint(this,Hs)
%SETSYSOBJFIXEDPOINT Set converted System object fixed point properties

%   Copyright 2011-2012 The MathWorks, Inc.

if ~this.CastBeforeSum
  warning(message('dsp:quantum:basecatalog:InvalidCastBeforeSum','DFILT',class(Hs)))
end

Hs.ReflectionCoefficientsDataType = 'Custom';
  
sgn = getSign(Hs,'CustomReflectionCoefficientsDataType');
if isempty(sgn)
  if ~this.Signed
    warning(message('dsp:quantum:basecatalog:InvalidUnsignedArithmetic','DFILT',class(Hs)));
  end
else  
  sgn = this.Signed;
end
Hs.CustomReflectionCoefficientsDataType = ...
  numerictype(sgn, this.CoeffWordLength, this.LatticeFracLength);

if isprop(Hs,'FullPrecisionOverride')
  % Always specify precision since we do not have a full precision
  % FilterInternals mode
  Hs.FullPrecisionOverride = false;  
end

if ~strcmp(this.ProductMode,'FullPrecision') 
  sgn = getSign(Hs,'CustomProductDataType');
  Hs.ProductDataType = 'Custom';
  Hs.CustomProductDataType = ...
    numerictype(sgn, this.ProductWordLength, this.ProductFracLength);
end

if ~strcmp(this.AccumMode,'FullPrecision')
  sgn = getSign(Hs,'CustomAccumulatorDataType');  
  Hs.AccumulatorDataType = 'Custom';
  Hs.CustomAccumulatorDataType = ...
    numerictype(sgn, this.AccumWordLength, this.AccumFracLength);
end
  
sgn = getSign(Hs,'CustomStateDataType');
Hs.StateDataType = 'Custom';
Hs.CustomStateDataType = ...
  numerictype(sgn, this.StateWordLength, this.StateFracLength);

sgn = getSign(Hs,'CustomOutputDataType');
Hs.OutputDataType = 'Custom';
Hs.CustomOutputDataType = ...
  numerictype(sgn, this.OutputWordLength, this.OutputFracLength);

Hs.RoundingMethod = maproundmode(this);
Hs.OverflowAction = this.OverflowMode;
  
function sgn = getSign(Hs,prop)
fptRestrictions = getFixedPointRestrictions(Hs,prop);
if any(strcmp(fptRestrictions,'AUTOSIGNED'))
  sgn = [];
else
  sgn = true;
end
  