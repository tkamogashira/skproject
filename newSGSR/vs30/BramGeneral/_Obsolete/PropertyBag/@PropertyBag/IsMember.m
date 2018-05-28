function boolean = IsMember(PB, Name)
%PROPERTYBAG/ISMEMBER   check if property is element of bag.
%   ISMEMBER(PB, Name) returns 1 if the property with the specified
%   name is in the property bag PB and 0 if not. If Name is replaced
%   by a 1-by-N or N-by-1 cell array of strings containing property
%   names, then ISMEMBER will return a 1-by-N or a N-by-1 vector with
%   1 where the corresponding property name is in the bag and zero when
%   the property is not in the bag.
%   Attention! Property names or case-insensitive and only enough characters
%   need to be supplied to uniquely identify a property in a bag.

%B. Van de Sande 10-05-2004

if (nargin ~= 2) & ~isa(PB, 'PropertyBag'), error('Wrong input arguments.'); end

if iscellstr(Name),
    N = length(Name);
    for n = 1:N, boolean(n) = IsMember(PB, Name{n}); end %Use recusrion ...
    boolean = reshape(boolean, size(Name));
elseif ischar(Name), 
    boolean = ismember({PB.Properties.name}, lower(Name)) | ...
        (length(strmatch(lower(Name), char(PB.Properties.name))) == 1);
else, error('Invalid property name.'); end