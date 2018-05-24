function disp(this)
%DISP   Display this object.

%   Author(s): V. Pellissier
%   Copyright 2006 The MathWorks, Inc.

dispheader(this);
dispinfo(this.Input,'Input: ');
dispinfo(this.Output,'Output: ');
dispinfo(this.Product,'Product: ');
dispinfo(this.Accumulator,'Accumulator: ');
dispinfo(this.Multiplicand,'Multiplicand: ');
dispinfo(this.FDProduct,'FDProduct: ');

% [EOF]
