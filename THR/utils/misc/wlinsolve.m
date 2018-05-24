function [X, Rdef] = wlinsolve(A,y,w)
% WLINSOLVE - solve linear system A*X=B using weight factors for B data
%   [X, Rdef] = WLINSOLVE(A,B,W) solves the linear system A*X=B using
%   mldivide. Array W contains weight factors for the corresponding 
%   elements of B. W defaults to equal weights for all pairs when omitted, 
%   in which case the call is equivalent to X = B\A.
%   Rdef is the rank deficiency of the weighted matrix A. If Rdef>0, the
%   rank of A is deficient and the problem is ill conditioned.
%
%   The dimensions of the inputs must be:
%   A: (M,N)
%   B: (M,Z) may be a matrix, when multiple fits (Z) are desired
%   W: (M,1) must be an column array
%
%   See also LINSOLVE, mldivide, SNR2w.


error(nargchk(2,3,nargin));

%check sizes of the input variables
M_A = size(A,1); % # rows in A
N_A = size(A,2); % # cols in A

if nargin < 3, %provide equal weights if not specified by user
    w = ones(M_A,1);
end

% first dimension of y and w must be M_A
if size(y,1) ~= M_A
    error('Input variable Y of wrong dimension compared to A.');
end
if size(w,1) ~= M_A
    error('Input variable W of wrong dimension compared to A.');
end
% second dimension of w must be 1
if size(w,2) ~= 1
    error('Input variable W is not a column array.');
end

if isequal(0, sum(w)),
    error('All weights to wlinsolve are zero - no solution here');
end
w = w/sum(w); % avoid excessively large or small w values; they may cause numerical noise
Sw = sqrt(w); %sqrt of normalized weight factors because squared sum is minimized
Yw = y.*SameSize(Sw, y); % apply weights row-wise to y
Aw = A.*SameSize(Sw, A); % apply weights row-wise to A

Rdef = size(Aw,2)-rank(Aw); % rank deficiency of the weighted A
if  Rdef==0, % okay, no defieciency
    X = mldivide(Aw,Yw); %do left division
else, %rank deficient, return NaN
    X = NaN*ones(size(Aw,2),1);
end





