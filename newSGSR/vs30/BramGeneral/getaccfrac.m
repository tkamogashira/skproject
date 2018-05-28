function f = getaccfrac(func, c, Xdata, Ydata)
%GETACCFRAC get fraction of variance accounted for
%   GETACCFRAC(Func, c, Xdata, Ydata) gives the fraction of variance accounted for by a curvefit, which is
%   given by the function Func and the set of constants c. The original data is given by Xdata and Ydata.

%B. Van de Sande 09-05-2003

%Variance = sum((mean(Ydata) - Ydata).^2);
%Residual = sum((feval(func, c, Xdata) - Ydata).^2);
%f = 1 - (Residual/Variance);

if ~(size(Xdata, 1) > 1)
    Xdata = Xdata(:);
    Ydata = Ydata'; 
end

Variance = (mean(Ydata(:)) - Ydata).^2;
Variance = sum(Variance(:));

Residual = (feval(func, c, Xdata) - Ydata).^2;
Residual = sum(Residual(:));

f = 1 - (Residual/Variance);
