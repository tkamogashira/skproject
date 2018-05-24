function loadr14(H,s)
%LOADR14   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

H.States = s.States;
H.NumSamplesProcessed = s.NumSamplesProcessed;
H.BlockLength = s.BlockLength;
H.NonProcessedSamples = s.NonProcessedSamples;

% [EOF]
