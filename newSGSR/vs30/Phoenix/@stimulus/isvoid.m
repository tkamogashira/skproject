function iv = isvoid(ST);
% stimulus/isvoid - true for void stimulus objects
%   isvoid(ST) returns true if ST is a void stimulus object.
%   A void stimulus objects results from a call to
%   the Stimulus constructor without any input arguments.
%
%   See also Stimulus.

iv = isempty(ST.name);


