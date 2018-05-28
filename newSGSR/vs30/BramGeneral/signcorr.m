function [p, C, DF] = signcorr(X1, X2)
%SIGNCORR   significance of correlation coefficient
%   [p, C, DF] = SIGNCORR(X1, X2)

CM = corrcoef(X1, X2);
if ~isnan(CM),
    C = CM(2,1);

    DF = length(X1) - 2;         %Degrees of freedom ...
    TS = C * ((DF/(1-C^2))^0.5); %Test statistic ...

    p = 1 - tcdf(abs(TS), DF);
else,
    p = NaN;
    C = NaN;
    DF = NaN;
end
%T = tinv(0.95, DF);
% if |ts|>t then r significant at 0.95 level: p<0.05 that r=0   
%if abs(ts)>t
%   titlestring=sprintf('r significant (p < 0.05)');
%else 
%   titlestring=sprintf('r not sign. <> from 0 (p > 0.05)');
%end