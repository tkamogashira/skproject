function X = replaceEmpty(X, Xdef);
% replaceEmpty - replace empty value by a specifed value
%    replaceEmpty(X,Xdef) returns X if ~isempty(X), Xdef otherwise.
%
%     See also arginDefaults, replaceScalar.

if isempty(X), X = Xdef; end


