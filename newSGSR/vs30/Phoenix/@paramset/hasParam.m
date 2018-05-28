function [hp, Index] = hasParam(S, paramName);
% paramset/hasParam - true if param is in paramset object.
%   hasParam(S, paramName) returns true if paramName is
%   the name of a parameter contained in S.
%   Parameter names are case insensitive.
%
%   [HP, I] = hasParam(S, paramName) also returns the index
%   of the parameter within the collection of parameters in S.
%   Index = [] if the param is not in S.
%
%   See also Paramset/ParamIndex, Paramset, Parameter.

Index = ParamIndex(S, paramName);
hp = ~isnan(Index);

