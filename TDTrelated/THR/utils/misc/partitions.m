function M = partitions(N, k);
% partitions - all partitions of an integer
%    M = partitions(N) returns all partitions of integer N as a matrix.
%    Each row of M is a partition of N into non-negative integers.
%
%    M = partitions(N,k) only returns those partitions of N containing
%    at most k nonzero terms.
%
%    For vectors N, the partitions for consecutive elements N(j) are 
%    vertically concatenated.

if nargin<2,
    k = max(N); % default
end
%disp(['N=' num2str(N) '   k=' num2str(k)]);
if length(N)>1,
    M = [];
    for ii=1:numel(N),
        M = [M; partitions(N(ii),k)];
    end
    return;
end

%-------single-valued N from here---------
if N<0, % trivial case: nothing to partition
    M = [];
elseif N==0, % trivial case: partitioning zero
    M = zeros(1,k);
elseif k==1, % trivial case of single term
    M = N;
else, % nontrivial cases: use recursion
    M = [];
    for kk=max(k,N):-1:0,
        Mm1 = partitions(N-kk,k-1);
        n = size(Mm1,1); 
        Mm1 = [kk*ones(n,1) Mm1];
        M = [M; Mm1];
    end
end





