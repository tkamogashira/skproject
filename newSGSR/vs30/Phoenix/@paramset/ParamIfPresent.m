function P = ParamIfPresent(S, pname, fieldname, default);
% paramset/ParamIfPresent - return parameter of paramset if it exists
%   ParamIfPresent(S, 'foo') returns parameter foo of paramset object S,
%   if foo is a parameter of S. If not, a void parameter is returned.
%
%   ParamIfPresent(S, 'foo', fieldname) returns the fieldname of
%   parameter foo, nan otherwise. Fieldname must be a valid
%   fieldname for parameters (see parameter/subsref) ;
%
%   ParamIfPresent(S, 'foo', fieldname, defValue) uses defValue
%   as the default return value rather than nan.
%
%   See also paramset/hasparam.

if nargin<4, default = nan; end;

if hasparam(S, pname), P = getfield(S, pname);
else, P = parameter; % void parameter
end;

if nargin>2,
   if isvoid(P), P = default;
   else, P = getfield(P, fieldname);
   end
end






