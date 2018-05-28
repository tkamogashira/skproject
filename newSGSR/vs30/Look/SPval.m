function y = SPval(SP, shortname,isub);
% SPval - return value(s) of SPstruct element
%   SPval(SP,shortname) returns the value field of the element of SP with 
%   specified shortname.
%
%   SPval(SP,shortname,isub) returns the isub-th value
%   or the first-and-only value if the value field is a scalar.
%
% See also SPstruct, SPelem, SPlist.


y = SPelem(SP, shortname, 'value');
if nargin>2
   if length(y)>1,
      y = y(isub);
   end
end