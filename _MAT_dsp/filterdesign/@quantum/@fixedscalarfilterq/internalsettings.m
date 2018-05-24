function s = internalsettings(q)
%INTERNALSETTINGS Returns the fixed-point settings viewed by the algorithm.  

%   Author(s): V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

s.CoeffWordLength = q.privcoeffwl;
s.CoeffFracLength = q.privcoefffl;
s.Signed = q.privsigned;
s.InputWordLength = q.InputWordLength;
s.InputFracLength = q.InputFracLength;
s.OutputWordLength = q.OutputWordLength;
s.OutputFracLength = q.privoutfl;
if strcmpi(q.OutputMode, 'BestPrecision'),
    s.OutputFracLength = NaN;
end

% [EOF]
