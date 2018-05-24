function p = setrefpolym(Hd, p)
%SETREFPOLYM Overloaded set on the refpolym property.
  
%   Author: V. Pellissier
%   Copyright 1988-2004 The MathWorks, Inc.

validaterefcoeffs(Hd.filterquantizer, 'Numerator', p);
