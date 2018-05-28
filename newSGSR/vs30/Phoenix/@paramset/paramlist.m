function L = paramlist(S);
% paramset/paramlist - list of all parameter names of paramset
%   Paramlist(S) returns a list of all parameter names 
%   of paramset S. The list is a cell array of strings.
%
%   See also Paramset, Parameter.

if isempty(S.Stimparam), L = {};
else, 
   SP = struct(S.Stimparam);
   L = {SP.Name};
end