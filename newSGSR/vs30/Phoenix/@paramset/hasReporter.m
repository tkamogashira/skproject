function [hr, Index, rnames] = hasReporter(S, Name);
% paramset/hasReporter - true if paramset object contains named reporter.
%   hasReporter(S, Name) returns true if Name is 
%   the name of reporter contained in S.
%   Reporter names are case insensitive.
%
%   [HR, I, AR] = hasQuery(S, Name) also returns the index I
%   of the reporter in the S.OUI.reporter struct array, and
%   a list AR of all reporter names of S.
%   Index = [] if the reporter is not in S.
%
%   See also Paramset/HasQuery, Paramset/AddReporter.

rnames = {S.OUI.reporter.name};
Index = strmatch(lower(Name), lower(rnames));
hr = ~isempty(Index);


