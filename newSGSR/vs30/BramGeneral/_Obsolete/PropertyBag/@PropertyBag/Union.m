function PB = Union(PB1, PB2)
%PROPERTYBAG/UNION   combine two property bags.
%   PB = UNION(PB1, PB2) combines the supplied property bags into one bag, 
%   with all the properties and relations of the two combined. Duplicate 
%   properties or relations are not allowed.

%B. Van de Sande 13-05-2004

%Checking input arguments ...
if ~isa(PB1, 'PropertyBag') | ~isa(PB2, 'PropertyBag'),
    error('A property bag can only be united with another property bag.');
end

%Checking if properties are different ...
if ~isempty(intersect({PB1.Properties.name}, {PB2.Properties.name})),
    error('Two property bags can only be united if all property names are different.');
end

%Perform union ...
PB = Add(PB1, PB2.Properties);
PB = Add(PB, PB2.Relations);