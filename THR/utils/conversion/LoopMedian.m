function [X, M] = LoopMedian(X,N,flag)
%  LoopMedian - median of the subsequent cycles of an array
%    LoopMedian(X,N) returns the pointwise median of X(1:N), X(N+1:2N), etc.
%    N defines the length of the returned median. 
%    It is required that length(X)/N is an integer.
%    The output is of the same kind (column/vector array) as the input X.
%
%    LoopMedian(X,N,'zeromean') first subtracts the mean of each cycle 
%    before calculating the median across cycles. The grand mean of X is 
%    then added to the result.
%
%    For a matrix X, loopMedian operates on the columns of X.
%
%    [Y, M] = LoopMedian(X,N) also returns the number M of averaged loops
%    i.e., M = length(X)/N.
%
%    See also LoopMean, Reshape, Mean.

if nargin<3,
    flag='';
end
Zmean = 0;
if isempty(flag),
elseif isequal('zeromean', lower(flag)),
    Zmean = 1; 
else,
    error(['Invalid flag ''' flag '''.']);
end
isrow = isvector(X) && size(X,2)>1;
if isrow, X = X(:); end

Sz = size(X);
N1 = Sz(1);
if ~isequal(0,rem(N1,N)),
    error('Input X must contain exact number of loops.');
end
M = round(N1/N); % # loops
X = reshape(X, [N M Sz(2:end)]); % break up 1st dim in (1,2) dim
if Zmean, % remove means per cycle, i.e. in 1st dim
    X = X - repmat(mean(X,1), [size(X,1) 1]);
end
X = squeeze(median(X,2)); % average away dim 2 and remove dim 2

if isrow,
    X = X.';
end

