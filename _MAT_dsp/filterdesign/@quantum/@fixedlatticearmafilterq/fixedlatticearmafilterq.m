function q = fixedlatticearmafilterq
%FIXEDLATTICEARMAFILTERQ   Construct a FIXEDLATTICEARMAFILTERQ object.

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

q = quantum.fixedlatticearmafilterq;

% Force the default AccumWordLength
q.AccumWordLength = 40;

% [EOF]
