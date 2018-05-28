function ir = issinglerealnumber(X, flag);
% issinglerealnumber - true for real scalars
%   issinglerealnumber(X) returns True if X is is a real-valued scalar,
%   False otherwise. NaNs are not real scalars, but inf and -inf are
%   allowed.
%
%   issinglerealnumber(X, 'noninf') rejects inf and -inf.
%
%   issinglerealnumber(X, 'integer') only accepts non-inf integers.
%
%   issinglerealnumber(X, 'posinteger') only accepts positive, finite
%   integers.
%
%   issinglerealnumber(X, 'nonneginteger') only accepts nonnegative, finite
%   integers.
%
%   See also ISSCALAR, NumericTest.

if nargin<2, flag=''; end
if ~ismember(lower(flag), {'', 'noninf' 'integer' 'posinteger' 'nonneginteger'}),
    error(['Invalid flag argument ''' flag '''.']);
end

ir = false; % pessimistic default

if ~isequal(1, numel(X)),
elseif ~isnumeric(X),
elseif ~isreal(X),
elseif isnan(X),
elseif isequal('noninf', lower(flag)) && isinf(X),
elseif isequal('integer', lower(flag)) && (isinf(X) || ~isequal(X,round(X))),
elseif isequal('posinteger', lower(flag)) && (isinf(X) || ~isequal(X,round(X)) || (X<=0)),
elseif isequal('nonneginteger', lower(flag)) && (isinf(X) || ~isequal(X,round(X)) || (X<0)),
else, % passed all tests
    ir = true;
end



