function varargout = SameSize(varargin);
% SameSize - make set of variables equal in size
%   [A,B,..] = SameSize(A,B,..) uses repmat to force upon A,B, .. 
%   the same size. Input arguments may not be emmpty and must have
%   compatible sizes, i.e., in each dimension the size may either be 1 or a
%   unique M>1.
%
%   Examples
%      [A,B] = SameSize(1:5, 'q') returns
%           A = [1 2 3 4 5]
%           B = 'qqqqq';
%      [A,B,C] = SameSize(7, ones(1,2), zeros(3,1))  returns
%       A =
%            7     7
%            7     7
%            7     7
%       B =
%            1     1
%            1     1
%            1     1
%       C =
%            0     0
%            0     0
%            0     0
%
%       See also REPMAT, SIZE, NDIMS.

% determine max dimensionality among inputs
Ndim = cellfun(@ndims, varargin);
Ndim = max(Ndim);

if any(cellfun('isempty', varargin)),
    error('Empty input argument.');
end
CommonSize = ones(1,Ndim); % this is going to be the one size fits all
for idim =1:Ndim,
    dim = cellfun('size', varargin, idim);
    % each dim may be either 1 or a unique M>1
    if length(unique(dim(dim>1)))>1,
        error(['Incompatible sizes in dimension #' num2str(idim) '.'])
    end
    CommonSize(idim) = max(dim);
end

for iarg=1:nargin,
    X = varargin{iarg};
    sz = ones(1,Ndim); % need size vector containing all dimensions
    sz(1,1:ndims(X)) = size(X);
    repper = round(CommonSize./sz);
    varargout{iarg} = repmat(X,repper);
end


