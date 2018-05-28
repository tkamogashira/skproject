function Index = ParamIndex(S, paramName);
% paramset/ParamIndex - internal index of parameter within paramset object.
%   ParamIndex(S, paramName) returns returns the index
%   of the parameter within the collection of parameters in S.
%   Nan is returned if the param is not in S.
%
%   Note: parameter names are case-insensitive.
%
%   See also Paramset/hasParam, Paramset, Parameter.

p =lower(paramName);
plist = lower(paramlist(S));
Index = strmatch(p, plist, 'exact');
if isempty(Index), Index = NaN; end

