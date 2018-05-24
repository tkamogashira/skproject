function q = fixeddf1sosfilterq
%FIXEDDF1SOSFILTERQ   Construct a FIXEDDF1SOSFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

q = quantum.fixeddf1sosfilterq;

% Force defaults
q.fimath.SumWordLength = 40;
q.fimath.SumFractionLength = 30;
q.fimath2.SumWordLength = 40;
q.fimath2.SumFractionLength = 30;

% Fire set functions
nstWL = q.NumStateWordLength;
q.NumStateWordLength = nstWL+1;
q.NumStateWordLength = nstWL;

% [EOF]
