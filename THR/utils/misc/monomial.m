function [mv, Part] = Monomial(k,varargin);
% Monomial - Evaluate monomial in several variables
%   M = Monomial(k, X1, X2, .., XN) returns the value of the kth monomial 
%   in N variables. N-Monomials are sorted as follows
%
%      1, X1, X2 ... XN, X1^2, X1*X2, X1*X3 ... X1*XN, X2^2, X2*X3, ...
%
%   Thus low-order monomials precede higher-order ones, and within the same
%   order, higher powers of Xi precede those of Xj when i<j. To view the
%   order of the N-dim monomial terms explicitly, type Partition(0:K,N),
%   where K is the highest power included, and N is the number of
%   variables.
%
%   k may be a row vector, in which case M is a row vector containing the
%   values of the monomial corresponding the elements of k.
%
%   [M, P] = Monomial(k, X1, X2, .., XN) also returns the value vector P
%   whose elements are the powers to which respective elements Xi are
%   raised. P(i,j) is the power to which Xi is raised in evaluating
%   monomial k(j). 
%
%   The Xi may be arrrays or matrices having the same or compatible size 
%   (see SameSize), in which case M and P are arrays or matrices
%   whose elements correspond to those of the Xi.
%
%   If both k and the Xi are vectors, M and P are matrices whose columns 
%   and rows correspond the corresponding elements of k and Xi, respectively. 
%   Note that M is a generalization of the Vandermonde matrix.
%   
%   Examples
%     Monomial(1:7,X,Y) equals [1, X, Y, X^2, X*Y, Y^2 X^3]
%     Partitions(0:2,3) lists the respective powers of 3-D monomials up to 
%               order 2 in a Mx3 matrix. Each row [k l m] indicates a 
%               term X^k*Y^l*Z^m
%
%   See also polyval, polyval2d, SameSize, VANDER, Partitions.

X = varargin;
Nx = length(X); % # different X's (=monomial args)

[X{:}] = SameSize(varargin{:});
if (length(k)>1) && ~isvector(X{1}),
    error('When k is a vector, the Xi''s cannot be matrices.');
end

Xsize = size(X{1});
for iX = 1:Nx,
    X{iX} = X{iX}(:); % force into column vectors
end

if length(k)>1, % recursion
    mv= []; Part = [];
    for ii=1:length(k),
        [mm, pp] = monomial(k(ii), X{:});
        mv = [mv, mm];
        Part = [Part, pp];
    end
    return;
end

%--------single k from here --------------
X = [X{:}]; % matrix whose columns are the Xi's
% find out what the kth monomial is
K = Nx;
while 1,
    Part = partitions(0:K, Nx);
    if size(Part,1)>=k, break; end
    K = K+1;
end
Part = Part(k,:).';
Power = SameSize(Part.',X);
mv = prod((X.^Power),2);
mv = reshape(mv,Xsize);









