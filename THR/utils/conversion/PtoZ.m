function Z = PtoZ(p);
% PtoZ - convert Proportion to Z-Score
%    PtoZ(P) returns the Z-score of a proportion P.
%    Defined in terms of the error function erf as
%          Z = -sqrt(2)*erfinv(2*P-1)
%
%    See also ZtoP.

%          P = (erf(Z/sqrt(2))+1)/2

if any(abs(p(:)-0.5)>0.5),
   error('p must be number between 0 and 1.');
end

Z = -sqrt(2)*erfinv(2*p-1);

% ========below the numerical approx after Les Bernstein's code
% NOte that the sign of Z has been reversed in order to make PtoZ
% the true inverse function of ZtoP.

%    Based on Les Bernstein's code (stats unit).
%
%p = max(p,1e-6);
%T = sqrt(log(1./p.^2));
%Num = 2.515517 + (0.802853*T) + (0.010328*T.^2);
%Den = 1 + (1.432788*T) + (0.189269*T.^2) + (0.001308*T.^3);
%Z  = T - (Num./Den);
