function Value = Get(PB, Name)
%PROPERTYBAG/GET    get value of property in a bag.
%   V = GET(PB, Name) returns the value of the specified property
%   for the property bag PB. If Name is replaced by a 1-by-N or 
%   N-by-1 cell array of strings containing property names, then
%   GET will return an M-by-N cell array of values.
% 
%   GET(PB) displays all property names and their current values for
%   the property bag PB.
% 
%   S = GET(PB) returns a structure S where each field name is the
%   name of a property of PB and each field contains the value of
%   that property.
%
%   Attention! Property names or case-insensitive and only enough characters
%   need to be supplied to uniquely identify a property in a bag.

%B. Van de Sande 13-05-2004

%Check input parameters ...
if ~any(nargin == [1, 2]), error('Wrong number of input parameters.'); end
if ~isa(PB, 'PropertyBag'), error('First argument should be property bag.'); end

%Return or display properties and their values ...
if (nargin == 1),
    if (nargout >= 1), 
        Args = vectorzip({PB.Properties.name}, {PB.Properties.value});
        Value = CreateStruct(Args{:});
    else, disp(PB, 'propvalues'); end
%Return value of requested property ...
elseif (nargin == 2),
    if ischar(Name),
        idx = findProperty(PB, Name);
        if isempty(idx), error(sprintf('Property ''%s'' is not in property bag.', Name));
        elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', Name));
        else, Value = PB.Properties(idx).value; end
    elseif iscellstr(Name),  
        N = prod(size(Name));
        for n = 1:N, Value{n} = get(PB, Name{n}); end %Use recursion ...
        Value = reshape(Value, size(Name));
    else, error('Name of property must be supplied as character string or cell-array of strings.'); end
end