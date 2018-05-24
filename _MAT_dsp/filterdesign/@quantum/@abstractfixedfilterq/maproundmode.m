function roundingMethod = maproundmode(this)
%MAPROUNDMODE Map RoundMode enum to System object RoundMethod enum

%   Copyright 2011 The MathWorks, Inc.

rm = this.RoundMode;
switch lower(rm)
  case 'convergent'
    roundingMethod = 'Convergent';
  case 'ceil'
    roundingMethod = 'Ceiling';
  case 'fix'
    roundingMethod = 'Zero';
  case 'floor'
    roundingMethod = 'Floor';
  case 'round'
    roundingMethod = 'Round';
  case 'nearest'
    roundingMethod = 'Nearest';
  otherwise
    warning(message('dsp:quantum:basecatalog:NoRoundingModeMapping',class(this)));
end

% [EOF]