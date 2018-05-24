function Hd = dispatch(h)
%DISPATCH  Return equivalen DFILT object.

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

num = h.Coefficients;
if signalpolyutils('islinphase',num,1),
    if strcmpi('symmetric',signalpolyutils('symmetrytest',num,1)),
        Hd = lwdfilt.symfir(num);
    else
        Hd = lwdfilt.asymfir(num);
    end
else
    Hd = lwdfilt.tf(num,1);
end

