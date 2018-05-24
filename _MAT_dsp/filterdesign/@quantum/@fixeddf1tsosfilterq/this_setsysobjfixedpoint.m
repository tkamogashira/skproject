function this_setsysobjfixedpoint(this,Hs)
%THIS_SETSYSOBJFIXEDPOINT

%   Copyright 2011 The MathWorks, Inc.

setsysobsectioninputoutput(this,Hs);

Hs.MultiplicandDataType = 'Custom';
Hs.CustomMultiplicandDataType = ...
  numerictype([],this.MultiplicandWordLength, this.MultiplicandFracLength);

Hs.NumeratorStateDataType = 'Custom';
Hs.CustomNumeratorStateDataType = ...
  numerictype([],this.StateWordLength, this.NumStateFracLength);
Hs.DenominatorStateDataType = 'Custom';
Hs.CustomDenominatorStateDataType = ...
  numerictype([],this.StateWordLength,this.DenStateFracLength);

% [EOF]