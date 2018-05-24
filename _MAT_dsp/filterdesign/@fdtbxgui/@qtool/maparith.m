function arith = maparith(this, arith)
%MAPARITH   Map the arithmetic

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

if nargin < 2, arith = this.Arithmetic; end

switch lower(arith)
    case 'double-precision floating-point'
        arith = 'double';
    case 'single-precision floating-point'
        arith = 'single';
    case 'fixed-point'
        arith = 'fixed';
    case 'integer'
        arith = 'int';
end

% [EOF]
