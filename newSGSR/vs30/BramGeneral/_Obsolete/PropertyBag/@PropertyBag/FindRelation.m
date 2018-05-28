function idx = FindRelation(PB, Name)
%FINDRELATION    find relation by name in property bag.
%   Idx = FINDRELATION(PB, Name) returns the index in the structure-array of
%   relations of the supplied property name. The name is case-insensitive and
%   only enough characters need to be supplied to uniquely identify a property 
%   in a bag.
%
%   Attention! This function is an internal function belonging to the  
%   property bag object and should not be invoked from the MATLAB
%   command prompt.

%B. Van de Sande 10-05-2004

%Checking input arguments ...
if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~isa(PB, 'PropertyBag'), error('First argument must be property bag object.'); end   
if ~ischar(Name), error('Second argument needs to be name of property.'); end

idx = find(ismember({PB.Relations.name}, lower(Name)));
if isempty(idx),
    RelationsList = char(PB.Relations.name);
    idx = strmatch(lower(Name), RelationsList);
end