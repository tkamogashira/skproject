function setsysobsectioninputoutput(this,Hs)
%SETSYSOBSECTIONINPUTOUTPUT 

%   Copyright 2011 The MathWorks, Inc.

Hs.SectionInputDataType = 'Custom';
Hs.CustomSectionInputDataType = ...
  numerictype([],this.NumStateWordLength,this.NumStateFracLength);
Hs.SectionOutputDataType = 'Custom';
Hs.CustomSectionOutputDataType = ...
  numerictype([],this.DenStateWordLength,this.DenStateFracLength);

% [EOF]
