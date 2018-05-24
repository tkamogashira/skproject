function this_setsysobjfixedpoint(this,Hs)
%THIS_SETSYSOBJFIXEDPOINT

%   Copyright 2011 The MathWorks, Inc.
  
setsysobsectioninputoutput(this,Hs);

Hs.StateDataType = 'Custom';
Hs.CustomStateDataType = ...
  numerictype([],this.StateWordLength, this.StateFracLength);
      
% [EOF]