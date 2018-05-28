function [fv, s] = getFieldOrDefault(s,fn,def);
% GETFIELDORDEFAULT - return field of struct or default valueif field is not in struct
%    GETFIELDORDEFAULT(S,'Foo', D) returns S.Foo if field Foo exists
%    in S. If Foo is not a field of S, the default value D is returned.
%
%    [F, S] = GETFIELDORDEFAULT(S,'Foo', D) actually provides field Foo if
%    it wasn't there already.
%
%     See also GETFIELD.

error(nargchk(3,3,nargin));
if isstruct(s) && isfield(s,fn),
    fv = s.(fn);
elseif isobject(s),
    try,
        fv = s.(fn);
    catch,
        fv = def;
    end
else,
    fv = def;
end
if nargout>1,
    s.(fn) = fv;
end




