function varargout = sortAccord(varargin);
% sortAccord - sort array X according to the order of array Y
%    X = sortAccord(X,Y) returns X(I) where [dum, I] = sort(Y);
%    X and Y must have same lengths;
%
%    [X1 X2 ..] = sortAccord(X1, X2, ..,Y) sorts X1, X2, ...
%    according to Y's order

if isequal(nargin,2),
   X = varargin{1};
   Y = varargin{2};
   if ~isequal(length(X),length(Y)),
      error('X and Y must have same lengths.');
   end
   [dum, isort] = sort(Y);
   varargout{1} = X(isort);
else, % handle mutiple args by recursion (see help text for arg order)
   Y = varargin{nargin}; 
   for iarg = 1:nargin-1,
      varargout{iarg} = sortAccord(varargin{iarg}, Y);
   end
end




