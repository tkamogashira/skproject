function [X,N]=cellify(X)
% cellify - put value in 1-element cell array unless it is already a cell
%    cellify(X) returns X if X is a cell, {X} otherwise.
%
%    [C,N]=cellify(X) also returns the length N of the cell C.

if ~iscell(X),
    X = {X};
end
N = numel(X);

