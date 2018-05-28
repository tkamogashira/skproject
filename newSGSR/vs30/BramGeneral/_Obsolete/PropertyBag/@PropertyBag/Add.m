function PB = Add(PB, varargin)
%PROPERTYBAG/ADD    add property or relation to a property bag.
%   PB = ADD(PB, Name, Class, Dim, Range, Value) adds a new property to
%   the supplied property bag. The property is fully defined by its case-
%   insensitive name, its initial or default value and the constraints
%   on its value. To specify a constraint, one must give the name of
%   the class (e.g. double, char, ...), the dimensions and the range
%   on the value. Dimensions can be given as a scalar, a 2 or 3-element
%   vector or a string of the form '@x@' or '@x@x@' (where @ denotes an
%   integer number) specifying the number of elements in each dimension (e.g.
%   a scalar is 1, [1 1] or '1x1'). When a dimension is unrestricted use
%   Inf as value. The shortcuts 'empty', 'scalar', 'row' and 'column' are
%   also allowed and denote an empty vector, a scalar or a row- or columnvector
%   respectively. Range for numerical values is defined by a two-element
%   vector specifying a closed interval in between which the number should
%   be located or by a scalar when only a single value is allowed, for
%   character strings a cell-array of strings defines the set of all
%   allowed values (case-insensitve). To define mutiple constraints
%   for a property  class, dimension and range can be supplied as 
%   cell-arrays. Multiple contraints are combined using logical or.
%
%   PB = ADD(PB, Name, S, Value) adds a new property to the supplied
%   property bag, but where the constraints on the value are defined by
%   a structure (see below for information on the mandatory fields
%   in the structure).
%
%   PB = ADD(PB, Name, Class, Dim, Range) or PB = ADD(PB, Name, S) adds
%   a new constraint for a property already in the bag. 
%   
%   PB = ADD(PB, Name, Fnc, Value) adds a new property to the supplied
%   property bag, but where the constraints on the value are checked by
%   a function. This function must be supplied as a character string
%   or a function handle and must take three input arguments, the property
%   bag itself, the name of the property and the flag 'constraint'. If the
%   value of the property is valid the function should return 1, otherwise
%   0 should be returned.
%                   boolean = Fnc(PB, Name, 'constraint')
%   Attention! The constraints of a property are defined by a function or
%   by a structure-array, both ways cannot be used together. Moreover, only
%   one constraint function can be supplied for a property. 
%   The third input argument can be useful when combining all functions for
%   a property bag, be it for relations or constraints, in the same m-file.
%
%   PB = ADD(PB, Name, Fnc) adds a new relation to the property bag.
%   A relation is fully defined by a property name and a function, which
%   is executed whenever the property is set. The function must be supplied
%   as a character string or a function handle and must take the property bag
%   as input and output argument. The second argument passed to the function
%   is the name of the property, the last input argument is the string 'relation'.
%                     PB = Fnc(PB, Name, 'relation')
%   Attention! When adding a new relation, this is directly applied on the
%   property bag, to make sure there isn't an inconsistency in the
%   values of the properties. All the properties that are affected by the
%   function should therefore already be in the property bag. 
%   A property can only have one relation function associated with it.
%
%   PB = ADD(PB, S) adds a property or relation defined by the structure
%   S, this can also be an array of structures specifying multiple properties
%   or relations at once. The specify a property the structure S must contain
%   the following fields (case-sensitive):
%       S.name        : the case-insensitive name of the property.
%       S.constraints : a structure-array or a reference to a function (as
%                       character string or function handle) defining the
%                       constraints on the value for this property. 
%       S.value       : the initial value for this property.
%   Constraints can be given as a structure-array with the following fields:
%       S.class       : specify the class for the value.
%       S.dimensions  : specify the dimensions for the value.
%       S.range       : allowed range on the value.
%   The fields of a structure to define a relation between properties are:
%       S.name        : the name of the property that initiates the function.
%       S.function    : a character string or function handle.
%
%   Attention! Property names or case-insensitive and only enough characters
%   need to be supplied to uniquely identify a property in a bag. Of course
%   when adding a new property the full name must be given. 
%   The order in which the properties are added is not preserved in the property
%   bag. All properties are stored in alphabetical order.

%B. Van de Sande 18-05-2004

%Checking input arguments ...
if (nargin < 1) & ~isa(PB, 'PropertyBag'), error('First argument must be property bag object.'); end   

%PB = ADD(PB, Name, Class, Dim, Range, Value)
if (nargin == 6),
    [Name, Class, Dim, Range, Value] = deal(varargin{:});
    
    Name = ParsePropertyName(Name);
    if ismember(Name, {PB.Properties.name}), error(sprintf('Property ''%s'' already in property bag.', Name)); end
    
    Constraints = ParseConstraints(Class, Dim, Range);
    PB.Properties = Sort4Props([PB.Properties, lowerfields(CollectInStruct(Name, Constraints, Value))]);
    
    if ~isValidPropertyValue(PB, Name), error(sprintf('Supplied value for property ''%s'' isn''t compatible with contraint.', Name)); end    
%PB = ADD(PB, Name, Class, Dim, Range)    
elseif (nargin == 5),
    [Name, Class, Dim, Range] = deal(varargin{:});
    
    Name = ParsePropertyName(Name);
    idx = FindProperty(PB, Name);
    if isempty(idx), error(sprintf('Property ''%s'' is not already in property bag.', Name));
    elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', Name)); end
        
    Constraints = ParseConstraints(Class, Dim, Range);
    PB.Properties(idx).constraints = CombineConstraints([PB.Properties(idx).constraints, Constraints]);    
    
    if ~isValidPropertyValue(PB, Name), error(sprintf('Current value for property ''%s'' isn''t compatible with constraint.', Name)); end
%PB = ADD(PB, Name, Fnc, Value)
%PB = ADD(PB, Name, S, Value)
elseif (nargin == 4),
    [Name, Constraints, Value] = deal(varargin{:});
    
    Name = ParsePropertyName(Name);
    if ismember(Name, {PB.Properties.name}), error(sprintf('Property ''%s'' already in property bag.', Name)); end
    
    Constraints = ParseConstraints(Constraints);
    PB.Properties = Sort4Props([PB.Properties, lowerfields(CollectInStruct(Name, Constraints, Value))]);
    
    if ~isValidPropertyValue(PB, Name), error(sprintf('Supplied value for property ''%s'' isn''t compatible with contraint.', Name)); end
%PB = ADD(PB, Name, S)
elseif (nargin == 3) & isstruct(varargin{2}),
    [Name, Constraints] = deal(varargin{:});
    
    Name = ParsePropertyName(Name);
    idx = FindProperty(PB, Name);
    if isempty(idx), error(sprintf('Property ''%s'' is not already in property bag.', Name));
    elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', Name)); end
        
    Constraints = ParseConstraints(Constraints);
    PB.Properties(idx).constraints = CombineConstraints([PB.Properties(idx).constraints, Constraints]);
    
    if ~isValidPropertyValue(PB, Name), error(sprintf('Current value for property ''%s'' isn''t compatible with constraint.', Name)); end
%PB = ADD(PB, Name, Fnc)    
elseif (nargin == 3),
    [Name, Function] = deal(varargin{:});
    
    Name = ParsePropertyName(Name);
    idx = FindProperty(PB, Name);
    if isempty(idx), error(sprintf('Property ''%s'' is not already in property bag.', Name));
    elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', Name));
    else, Name = PB.Properties(idx).name; end
    if ismember(Name, {PB.Relations.name}), error('Only one relation is allowed for a property.'); end

    if isempty(Function) | ~(ischar(Function) | isa(Function, 'function_handle')),
        error('Relation function is not valid.');
    end
    try, PB = feval(Function, PB, Name, 'relation');
    catch, error('Relation function doesn''t exist or malfunctions.'); end    
    
    PB.Relations = Sort4Props([PB.Relations, lowerfields(CollectInStruct(Name, Function))]);
%PB = ADD(PB, S)
elseif (nargin == 2),
    if ~isstruct(varargin{1}), error('Second argument should be structure.'); 
    else, S = varargin{1}; end
    if isPropertyStruct(S),
        N = length(S);
        for n = 1:N, PB = Add(PB, S(n).name, S(n).constraints, S(n).value); end
    elseif isRelationStruct(S),
        N = length(S);
        for n = 1:N, PB = Add(PB, S(n).name, S(n).function); end %Use recusrion ...
    else, error('Invalid fieldnames in structure.'); end
else, error('Syntax error.'); end

%---------------------------locals-----------------------------
function boolean = isPropertyStruct(S)

boolean = isstruct(S) & all(ismember({'name', 'constraints', 'value'}, fieldnames(S)));

%--------------------------------------------------------------
function boolean = isRelationStruct(S)

boolean = isstruct(S) & all(ismember({'name', 'function'}, fieldnames(S)));

%--------------------------------------------------------------
function S = Sort4Props(S)

[dummy, idx] = sort({S.name});
S = S(idx);

%--------------------------------------------------------------