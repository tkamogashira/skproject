function q = fixedlatticefilterq
%FIXEDLATTICEFILTERQ   Construct a FIXEDLATTICEFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

q = quantum.fixedlatticefilterq;

% Force the default AccumWordLength
q.AccumWordLength = 40;

% [EOF]
