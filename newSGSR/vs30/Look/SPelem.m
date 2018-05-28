function y = SPelem(SP, shortname, fld);
% SPelem - element of SPstruct having a given shortname
%   SPelem(SP, shortname), where SP is a SPstruct array, returns
%   SP(j) with matching SP(j).shortname. Shortname is capitalized.
%
%   SPelem(SP, shortname, field), returns the specified field from the
%   selected SPstruct element
%
%   See also SPstruct, SPlist, SPval

y = [];
shortname = upper(shortname);
for ii=1:length(SP),
   if isequal(shortname, SP(ii).shortname),
      y = SP(ii);
   end
end
if isempty(y),
   error(['shortname ''' shortname ''' not found']);
end
if nargin>2,
   eval(['y = y.' fld ';']);
end



