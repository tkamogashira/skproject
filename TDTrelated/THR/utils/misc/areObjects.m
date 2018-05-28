function aw=areObjects(Wh, varargin);
% areObjects - test if args are objects of a given kind
%    areObjects('foo', X, Y, ...) is the row vector
%    [isfoo(X) isfoo(Y) ...]
%
%    See also ISCHAR, ARECHAR.

aw = [];
isfun = ['is' Wh];
for ii=1:nargin-1,
   aw = [aw, feval(isfun, varargin{ii})];
end

