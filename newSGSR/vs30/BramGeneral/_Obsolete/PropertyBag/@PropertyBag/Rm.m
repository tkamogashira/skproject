function PB = Rm(PB, Name)
%PROPERTYBAG/RM  remove property from a bag.
%   PB = RM(PB, Name) removes the specified property and if present its
%   associated relation from the supplied property bag. A cell-array
%   of property names can also be given.
%
%   Attention! Property names or case-insensitive and only enough characters
%   need to be supplied to uniquely identify a property in a bag.

%B. Van de Sande 13-05-2004

if (nargin ~= 2) & ~isa(PB, 'PropertyBag'), error('Wrong input arguments.'); end

if iscellstr(Name),
    N = length(Name);
    for n = 1:N, PB = Rm(PB, Name{n}); end %Use recursion ...
elseif ischar(Name),
    Name = ParsePropertyName(Name);
    
    %Remove property itself ...
    idx = FindProperty(PB, Name);
    if isempty(idx), error(sprintf('Property ''%s'' is not already in property bag.', Name));
    elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', Name)); end
    PB.Properties(idx) = [];
    
    %Remove relation ...
    idx = FindRelation(PB, Name); %Is unambiguous ...
    PB.Relations(idx) = [];
else, error('Invalid property name.'); end  