function X = ConstrMin(Q,CM,CV)
% ConstrMin - minimize quadratic form with linear constraints
%    X = ConstrMin(Q,CM,CV) finds N-dim column vector X 
%    that minimizes X'*Q*X while obeying the M linear constraints
%    CM*X = CV, where CM is M-by-N matrix and CV is M-dim vector;
%   (Q is assumed to be symmetric and positive definite)

N = size(Q,1); % length of vector X
M = size(CM,1); % # constraints

Q = (Q+Q')/2; % symmetrize just to be sure

% enlarge X with the M Lagrange multipliers, so that the
% problem becomes N+M dim, but now without the constraints:

Qtot = [Q, CM'; CM zeros(M)];
CVtot = [zeros(N,1); CV];

% extremizing 0.5*X'*Qtot*X - CVtot*X 
% is solving Qtot*X = CVtot
% This is done by MatLab's left division

X = Qtot\CVtot;
% remove the multipliers
X = X(1:N);


