function [hq, Index, qnames] = hasQuery(S, Name);
% paramset/hasQuery - true if paramset object contains named query.
%   hasQuery(S, QueryName) returns true if Name is parameter
%   for which a query is contained in S.
%   Parameter names are case insensitive.
%
%   [HQ, I, AQ] = hasQuery(S, paramName) also returns the index I
%   of the query in the S.OUI.item struct array, and a list of
%   all the names of queries in S. Index = [] if the query is not in S.
%
%   If S is a paramset array, HQ is a vector and I and AQ are cell arrays
%   whose ith elements contain the values returned by hasQuery(S(i), paramName).
%   Use any(hasQuery(S, Name)) to test if the named query occurs in any of
%   the paramsets in array S.
%
%   See also Paramset/HasParam, Paramset/HasReporter, Paramset/AddQuery.

if numel(S)>1, % recursive call
   [hq, Index, qnames] = deal([], {}, {});
   for ii=1:numel(S),
      [hq(ii) Index{ii} qnames{ii}] = hasQuery(S(ii), Name);
   end
   return
end

% single-element S from here

% select those items in S whose class equals 'query'
items = S.OUI.item;
iquery = strmatch('query', {items.class}, 'exact');
Q = S.OUI.item(iquery);

qnames = {Q.name};
% Index in Q!
Index = strmatch(lower(Name), lower(qnames)); 
% Index in item struct array
Index = iquery(Index);
hq = ~isempty(Index);

