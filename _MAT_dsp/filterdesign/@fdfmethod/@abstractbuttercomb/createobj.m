function Hd = createobj(this,coeffs)
%CREATEOBJ   Create the filter object from the coefficients.

%   Author(s): R. Losada
%   Copyright 2006 The MathWorks, Inc.


struct = get(this, 'FilterStructure');
Hd = feval(['dfilt.' struct], coeffs{:});

% [EOF]
