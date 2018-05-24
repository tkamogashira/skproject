function s = internalsettings(q)
%INTERNALSETTINGS   Returns fixed-point settings as viewed by the algorithm.  

%   Author(s): P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

              
% Input/Output
s.InputWordLength  = q.InputWordLength;
s.InputFracLength  = q.InputFracLength;
s.OutputWordLength = q.OutputWordLength;
s.OutputFracLength = q.OutputFracLength;

% Section WL/FL info
s.SectionWordLengths    = q.SectionWordLengths;
s.SectionFracLengths    = q.SectionFracLengths;

% Provided for programmatic consistency
s.RoundMode    = q.RoundMode;
s.OverflowMode = q.OverflowMode;
s.CastBeforeSum = q.CastBeforeSum;

% [EOF]
