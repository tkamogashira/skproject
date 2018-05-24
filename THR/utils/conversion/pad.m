function X=pad(X,N,val);
% pad - pad values to array or matrix.
%    X=pad(X,N) increases the length of array X by appending M=N-length(X)
%    zeros to its elements. If N<length(X), X is unaltered. 
%    For matrices, each column is padded. 
%
%    When X is a cell array, the individual cells of X are padded and 
%    then horzcatted. In this case N may be omitted or specified as [], 
%    and if so, N=max_k size(X{k},1) is used.
%
%    X=pad(X,-N) prepends M=N-length(X) zeros to a X.
%
%    X=pad(X,N,P) pads elements with value P instead of zeros.
%
%    EXAMPLES
%    pad(1:4, 10)
%    ans =
%         1     2     3     4     0     0     0     0     0     0
%    pad(zeros(2,3), 4, nan)
%    ans =
%         0     0     0
%         0     0     0
%       NaN   NaN   NaN
%       NaN   NaN   NaN
% 
%    pad({zeros(3,1) ones(5,3) rand(4)}, 5, nan)
%    ans =
%             0    1.0000    1.0000    1.0000    0.8326    0.5037    0.6763    0.0986
%             0    1.0000    1.0000    1.0000    0.3996    0.9314    0.7736    0.8998
%             0    1.0000    1.0000    1.0000    0.9461    0.4895    0.2768    0.0193
%           NaN    1.0000    1.0000    1.0000    0.6946    0.6487    0.3434    0.9747
%           NaN    1.0000    1.0000    1.0000       NaN       NaN       NaN       NaN

if nargin<2, N=[]; end;
if nargin<3, val = 0; end

if ~isempty(N),
    error(numericTest(N,'real/int/noninf/nonnan', 'Input argument N is ', 'singlevalue'));
end
error(dimensiontest(val,'singlevalue', 'Input argument P'))

% special case: cell array (see help)
if iscell(X),
    if isempty(N), % max size(X{j},1)
        N = max(cellfun('size', X, 1));
    end
    Y = [];
    for ii=1:numel(X),
        Y = [Y, pad(X{ii},N,val)];
    end
    X = Y;
    return
end
    
% ------not a cell from here -----------
isrow=0;
if isvector(X), % force into row vector
    isrow = isequal(1, size(X,1));
    X = X(:);
end

M = abs(N)-size(X,1);
if M>0,
    Xtr = repmat(val, M, size(X,2)); % values to be padded
    if N>0,
        X = [X; Xtr];
    else,
        X = [Xtr; X];
    end
end

if isrow, % restore shape
    X = X.'; 
end
