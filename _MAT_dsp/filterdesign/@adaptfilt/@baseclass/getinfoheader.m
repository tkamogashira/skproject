function str = getinfoheader(Ha)
%GETINFOHEADER

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

% Setup the title string
if isreal(Ha), typestr = 'real';
else,         typestr = 'complex'; end

if isfir(Ha), rtype = 'FIR';
else,        rtype = 'IIR'; end

str = sprintf('Discrete-Time %s Adaptive Filter (%s)', rtype, typestr);

% [EOF]
