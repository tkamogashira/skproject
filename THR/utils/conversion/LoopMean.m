function [X, M, AC] = LoopMean(X,N)
%  LoopMean - average the subsequent cycles of an array
%    LoopMean(X, N) returns the average of X(1:N), X(N+1:2N), etc.
%    N defines the length of the returned average. 
%    It is required that length(X)/N is an integer.
%    The output is of the same kind (column/vector array) as the input X.
%
%    LoopMean(X, -M) is the same as LoopMean(X, round(numel(X)/(-M))), i.e.
%    -M is the number of cycles.
%
%    For a matrix X, loopMean operates on the columns of X.
%
%    [Y, M] = LoopMean(X,N) also returns the number M of averaged loops
%    i.e., M = length(X)/N.
%
%    [Y, M, AC] = LoopMean(X,N) also returns the shuffled autocorrelation
%    AC across loops. This only works for arrays X See shufcorr.
%
%    See also LoopMedian, fracLoopMean, Reshape, Mean, shufcorr.

isrow = isvector(X) && size(X,2)>1;
if isrow, X = X(:); end
Sz = size(X);
N1 = Sz(1);
if N<0, % minus the # cycles
    N = round(N1/abs(N));
end
if ~isequal(0,rem(N1,N)),
    error('Input X must contain exact number of loops.');
end
M = round(N1/N); % # loops
X = reshape(X, [N M Sz(2:end)]); % break up 1st dim in (1,2) dim
if nargout>2, % compute AC
    AC = shufcorr(X);
end
X = squeeze(mean(X,2)); % average away dim 2 and remove dim 2

if isrow,
    X = X.';
end

