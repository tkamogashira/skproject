function g = factors(this,n)
%FACTORS   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

if n == 0
    g = 0;
else
    g = 1;
    f = factor(n);
    for k = 1:numel(f)
        g = [g prod(nchoosek(f,k),2)'];
    end
    g = sort(g);
    g(diff(g) == 0) = [];
end



% [EOF]
