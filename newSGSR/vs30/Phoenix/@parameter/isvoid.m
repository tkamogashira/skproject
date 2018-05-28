function iv = isvoid(Q);
% parameter/isvoid - true for void parameter objects
%   isvoid(Q) returns true if Q is a void parameter object
%   as resulting from a call to parameter without any arguments.
%
%   See also Parameter.

iv = isempty(Q.Name);




