function iv = isvoid(Q);
% paramset/isvoid - true for void paramset objects
%   isvoid(Q) returns true if Q is a void paramset object
%   as resulting from a call to paramset without any arguments.
%
%   See also Paramset.

iv = isempty(Q.Type);




