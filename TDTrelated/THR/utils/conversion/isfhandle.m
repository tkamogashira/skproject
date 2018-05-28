function i=isfhandle(X)
% ISFHANDLE - true function handle
%   ISFHANDLE(X) returns true (1) if X is a function handle, false (0) otherwise 

i = isa(X,'function_handle');


