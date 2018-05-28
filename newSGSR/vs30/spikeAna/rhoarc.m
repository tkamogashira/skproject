function rho = RHOARC(drho, N);
% RHOARC - vector of correlations that are evenly spaced on an arc
%   RHOARC(drho, N) returns the vector cos(phi) where 
%          phi = (0:N)*acos(1-drho).
%   This is useful when generating a collection of noise tokens
%   that are increasingly decorrelated with the first token using
%   a mix of two independent noise tokens A and B:
%      C = A*cos(phi) + B*sin(phi),
%   as is done in the NRHO stimulus menu of SGSR.
%   Because the C[i} are evenly spaced in terms of phi, the
%   correlation between C[i] and C[j] is only dependent on the
%   difference abs(i-j). More precisely, 
%      rho(i,j) = cos((i-j)*dphi), with dphi = acos(drho)/N, the smallest
%   spacing of rho.
%   Use RHOARC inside the rho edit field of the NRHO menu, e.g.:
%         rhoarc(0.003, 11)


DoSupply = N<0;
N = abs(N);
dphi = acos(1-drho);
phi = (0:N)*dphi;
% eliminate values > pi
phi = phi(find(phi<=pi));
% supply extra values to get a full coverage f the interval [0, pi]
M = 0;
if DoSupply, % supply extra values outside regular arc
   while max(phi)<pi,
      M = M + N+1;
      xphi = min(pi, M*dphi);
      phi = [phi xphi];
   end
else, % just add 0 and -1 corr, if necessary
   if max(phi)<pi/2, phi = [phi pi/2]; end
   if max(phi)<pi, phi = [phi pi]; end
end

rho = cos(phi);



