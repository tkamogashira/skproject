function boolean = isValidPropertyValue(PB, Name)
%ISVALIDPROPERTYVALUE   check validity of property value.
%   boolean = ISVALIDPROPERTYVALUE(PB, Name)
%
%   Attention! This function is an internal function belonging to the  
%   property bag object and should not be invoked from the MATLAB
%   command prompt.

%B. Van de Sande 17-05-2004

%Disassemble property bag ...
idx = findProperty(PB, Name);
if isempty(idx), error(sprintf('Property ''%s'' is not in property bag.', lower(Name))); 
elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', Name)); end
Name        = PB.Properties(idx).name;
Constraints = PB.Properties(idx).constraints;
Value       = PB.Properties(idx).value;

%Checking value of requested property ...
if isempty(Constraints), boolean = logical(1); %No constraints on value of property ...
elseif ischar(Constraints) | isa(Constraints, 'function_handle'), %Specific constraint function for this property ...
    try, boolean = feval(Constraints, PB, Name, 'constraint');
    catch, error(sprintf('Constraint function on property ''%s'' doesn''t exist or malfunctions.', Name)); end    
else, %Constraints on value are specified by a structure-array ...
    N = length(Constraints);
    if (N > 1), 
        for n = 1:N, boolean(n) = isValid(Constraints(n), Value); end
        boolean = any(boolean);
    else, boolean = isValid(Constraints, Value); end
end   

%---------------------------locals-----------------------------
function boolean = isValid(Constraint, Value)

boolean = logical(0); %Pessimistic approach ...

%Check class ...
if ~isa(Value, Constraint.class), return; end

%Check dimensions ...
[NX, NY, NZ] = size(Value); Sz = [NX, NY, NZ];
if ~isempty(Constraint.dimensions),
    if (length(Constraint.dimensions) == 1),
        if isequal(Constraint.dimensions, 0),
            if ~isempty(Value), return; end
        elseif isinf(Constraint.dimensions),
            Sz = sort(Sz); if ~isequal(Sz(1:2), [1 1]), return; end
        elseif ~isequal([1, 1, Constraint.dimensions], sort(Sz)), return; end
    else,
        idx = find(~isinf(Constraint.dimensions));
        if ~isempty(idx),
            if ~isequal(Constraint.dimensions(idx), Sz(idx)) & ~isempty(Value), return; end
        elseif ~isequal(Constraint.dimensions, Sz), return; end
    end    
end

%Check range ...
if ~isempty(Constraint.range),
    if isnumeric(Constraint.range) & (length(Constraint.range) == 1),
        if isnan(Constraint.range), boolean = all(isnan(Value));
        else, boolean = all(Constraint.range == Value); end
    elseif isnumeric(Constraint.range),     
        boolean = all((Value >= Constraint.range(1)) & (Value <= Constraint.range(2))); %Closed-interval ...
    else, boolean = any(strcmpi(Constraint.range, Value)); end %Case-insensitive ...
else, boolean = logical(1); end 

%--------------------------------------------------------------