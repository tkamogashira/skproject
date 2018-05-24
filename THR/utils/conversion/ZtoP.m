function P = ZtoP(Z);
% ZtoP - convert Z-Score to proportion
%    ZtoP(Z) returns the proportion P of a Z-score Z.
%    Defined in terms of the error function erf as
%          P = (erf(Z/sqrt(2))+1)/2
%
%    See also PtoZ.

P = (erf(Z/sqrt(2))+1)/2;

% ========below the numerical approx after Les Bernstein's code
% From Abramowitz Book
%D0 = 1;
%D1 = 0.04986734707;
%D2 = 0.0211410061;
%D3 = 0.0032776263;
%D4 = 0.0000380036;
%D5 = 0.0000488906;
%D6 = 0.0000053830;

%A = D0 + D1*Z + D2*Z.^2 + D3*Z.^3 + D4*Z.^4 + D5*Z.^5 + D6*Z.^6;
%P = 1 - (0.5*A.^(-16));
%P = max(0,P);