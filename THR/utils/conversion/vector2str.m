function Str = vector2str(X,varargin);
% vector2str - convert numerical array to string
%    S=vector2str(V) converts the numerical vector V to a string. If V is a
%    scalar, vectors2str(V) is the same as num2str(V). For row vectors
%    vector2str puts braces [] around the whitespace delimited numbers.
%    For column vectors the numbers are separated by semicolons.
%
%    S=vector2str(V,N) uses at most N digits. See NUM2STR..
%
%    EXAMPLES
%      vector2str(pi) returns '3.1416'
%      vector2str([1:4])  returns '[1 2 3 4]'
%      vector2str([pi;exp(1)])  returns '[3.1416; 2.7183]'
%
%    See also NUM2STR, deciround.

if ~isnumeric(X) || ~isvector(X),
    error('First argument must be numeric vector.');
end
% delegate to num2str
Str = num2str(X(:).', varargin{:});
% vectors need []
if ~isscalar(X), 
    Str = ['[' trimspace(Str) ']'];
end
if size(X,1)>1, % column vector. insert ';' between elements
    Str = strrep(Str,' ', '; ');
end

