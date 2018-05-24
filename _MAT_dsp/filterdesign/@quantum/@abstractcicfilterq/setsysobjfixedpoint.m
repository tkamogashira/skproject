function setsysobjfixedpoint(this,Hs)
%SETSYSOBJFIXEDPOINT Set converted CIC System object fixed point properties

%   Copyright 2011 The MathWorks, Inc.

switch this.FilterInternals
  case 'FullPrecision'
    Hs.FixedPointDataType     = 'Full precision';
  case 'MinWordLengths'
    Hs.FixedPointDataType     = 'Minimum section word lengths';
    Hs.OutputWordLength       = this.OutputWordLength;
  case 'SpecifyWordLengths'
    Hs.FixedPointDataType     = 'Specify word lengths';
    Hs.SectionWordLengths     = this.SectionWordLengths;
    Hs.OutputWordLength       = this.OutputWordLength;
  case 'SpecifyPrecision'
    Hs.FixedPointDataType     = 'Specify word and fraction lengths';
    Hs.SectionWordLengths     = this.SectionWordLengths;
    Hs.SectionFractionLengths = this.SectionFracLengths;
    Hs.OutputWordLength       = this.OutputWordLength;
    Hs.OutputFractionLength   =  this.OutputFracLength;
end

