function iv = isvoid(Q);
% query/isvoid - true for void query objects
%   isvoid(Q) returns true if Q is a void query object
%   as resulting from a call to query without any arguments.
%
%   See also Query.

iv = isempty(Q.Style);




