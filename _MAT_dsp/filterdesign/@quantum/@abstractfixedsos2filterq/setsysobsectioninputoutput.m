function setsysobsectioninputoutput(this,Hs)
%SETSYSOBSECTIONINPUTOUTPUT 

%   Copyright 2011 The MathWorks, Inc.

Hs.SectionInputDataType = 'Custom';
Hs.CustomSectionInputDataType = ...
  numerictype([],this.SectionInputWordLength,this.SectionInputFracLength);
Hs.SectionOutputDataType = 'Custom';
Hs.CustomSectionOutputDataType = ...
  numerictype([],this.SectionOutputWordLength, this.SectionOutputFracLength);

% [EOF]
