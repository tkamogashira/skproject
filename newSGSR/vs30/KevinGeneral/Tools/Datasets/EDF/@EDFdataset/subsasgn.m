function ds = subsasgn(ds, S, RHS);
%EDFDATASET/SUBSASGN - SUBSASGN for EDF dataset objects
%   Dataset variables contain raw data; they are read-only.
%   It is an error to change their contents.

%B. Van de Sande 12-08-2003

if (length(S) == 1) & isequal('()', S.type) & (isa(RHS, 'edfdataset') | isempty(RHS)),
   if isempty(ds), ds = EDFdataset;
   elseif ~isempty(RHS) & ~isequal(ds(1).ID.SchName, RHS.ID.SchName), error('Array of datasets can only contain datasets having the same schema.'); end 
   ds(S.subs{:}) = RHS;
else, error('Dataset variables contain raw data. Their content cannot be changed.'); end