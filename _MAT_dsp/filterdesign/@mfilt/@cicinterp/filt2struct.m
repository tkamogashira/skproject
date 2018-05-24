function s = filt2struct(this)
%FILT2STRUCT   Return the structure represenation of the filter.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

s.class                 = 'mfilt.cicinterp';
s.DifferentialDelay     = this.DifferentialDelay;
s.NumberOfSections      = this.NumberOfSections;
s.InterpolationFactor   = this.InterpolationFactor;
s.InputWordLength       = this.InputWordLength;
s.InputFracLength       = this.InputFracLength;
s.FilterInternals       = this.FilterInternals;


if strcmpi(s.FilterInternals,'minwordlengths'),
    s.OutputWordLength = this.OutputWordLength;
elseif strcmpi(s.FilterInternals, 'specifywordlengths'),
    s.OutputWordLength = this.OutputWordLength;
    s.SectionWordLengths = this.SectionWordLengths;
elseif strcmpi(s.FilterInternals, 'specifyprecision'),
    s.OutputWordLength = this.OutputWordLength;
    s.SectionWordLengths = this.SectionWordLengths;
    s.OutputFracLength = this.OutputFracLength;
    s.SectionFracLengths = this.SectionFracLengths;
end

% [EOF]
