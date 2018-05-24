function C = intersectspace(A,B, varargin);
% intersectspace - intersection of two linear spaces
%   intersectspace(A,B), where A is an m-by-na and B is a m-by-nb matrix,
%   returns an m-by-nc  matrix C spanning the nc-dim intersection of the
%   complex linear spaces spanned by A and B.Note that 
%   nc = rank(A)+rank(B)-rank([A B]).
%
%   intersectspace(A,B, tol) uses tolerance tol for rank estimation.
%   Default tol is 1e-6.
%
%   intersectspace(A,B,....) and intersectspace(A,B,...., tol) evaluates
%   the intersection of A,B,... .
%
%   Any cell arrays as input args are interpreted as unions (not sums!) of
%   their cells, i.e., each cell is a constituent subspace of the total
%   set. The intersection of two such sets is the set union of all the
%   intersections across pairs of constituents, one from each set. The
%   result is generally a composite set, i.e., a cell array, except in th
%   especial case of a single space or an empty one.
%
%   See also QR, RANK, reducespace.

if iscell(A), % expand and handle recursively
    C = {};
    for ii=1:numel(A),
        c = intersectspace(A{ii}, B, varargin{:});
        if ~isempty(c), C = [C c]; end
    end
    % reduce special cases
    if numel(C)==1, C = C{1};
    elseif numel(C)==0, C = [];
    end
    return;
elseif iscell(B), % swap args -> handled by previous case
    C = intersectspace(B,A,varargin{:});
    return;
end

% no cell arrays in A or B from here

if nargin>2, % extract any tolerance arg (single number)
    if isscalar(varargin{end}),
        tol = varargin{end};
        varargin = varargin(1:end-1);
    else,
        tol = 1e-6;
    end
else,
    tol = 1e-6;
end


if ~isempty(varargin), % more than two matrices: use recursion from left
    AB = intersectspace(A,B, tol);
    C = intersectspace(AB, varargin{:}, tol);
    return;
end

% ----single matrix pair from here---
nc = rank(A, tol)+rank(B, tol)-rank([A B], tol); % dimensionality of intersection
Ar = reducespace(A, tol);
Br = reducespace(B, tol);
% Ar*Ar' and Br*Br' project on domain(A) and domain(B), respectively. Any 
% vector X in their intersection has therefore Ar*Ar'*X = Br*Br'*X or
% (pA-pB')*X = 0. The intersection of dom(A) and dom(B) is
% therefore contained in the null space of (pA-pB).
pA = Ar*Ar'; % project to dom(A)
pB = Br*Br';  %project to dom(B)
C = nulltol(pA-pB, tol);
% The only problem is that pA and pB may have overlapping null spaces.
% These must be excluded from the result. This is easily done by projecting
% C to dom(A) or dom(B). [the choice is irrelevant, because C has
% pA*C= pB*C by construction]. 
C = reducespace(pA*C, tol);

% security check
if rank(C)~=nc,
    nc
    rC = rank(C)
    error('Rank problems.');
end

