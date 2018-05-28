function PB = Set(PB, varargin)
%PROPERTYBAG/SET    set value of a property in a bag.
%   PB = SET(PB, Name, Value) sets the value of the specified 
%   property for the supplied property bag.
% 
%   PB = SET(PB, S) where S is a structure whose field names are
%   property names, sets the properties named in each field name
%   with the values contained in the structure.
% 
%   PB = SET(PB, PN, PV) sets the named properties specified in the
%   cell array of strings PN to the corresponding values in the cell
%   array PV for all objects specified in PB.  The cell array PN and PV
%   must be 1-by-N.
% 
%   PB = SET(PB, Name1, Value1, Name2, Value2, ...) sets multiple
%   property values with a single statement.  Note that it is permissible
%   to use property/value string pairs, structures, and property/value
%   cell array pairs in the same call to SET.
%
%   Attention! In relation functions it can be necessary to set the value
%   of properties without executing the corresponding relation functions in
%   order to avoid recursive function cycles. This can be done by adding the
%   flag 'norelations' between the property bag object and the elements of
%   the desired syntax for specifying property values.
% 
%   A = SET(PB, Name) or SET(PB, Name) returns or displays the constraints
%   on the values for the specified property of the property bag PB. The
%   returned array is a cell array of possible value strings or an empty
%   cell array if the property does not have a finite set of possible string
%   values.
%    
%   A = SET(PB) or SET(PB) returns or displays all property names and their
%   possible values for the property bag PB. The return value is a structure
%   whose field names are the property names of PB, and whose values are 
%   cell arrays of possible property values or empty cell arrays.
%    
%   Attention! Property names or case-insensitive and only enough characters
%   need to be supplied to uniquely identify a property in a bag. Duplicate
%   references to the same property can be present in a the same call to SET,
%   but only the last reference mentioned will be taken into account.

%B. Van de Sande 17-05-2004

%Check input parameters ...
if (nargin == 0), error('Wrong number of input parameters.'); end
if ~isa(PB, 'PropertyBag'), error('First argument should be property bag.'); end

%Return or display properties and their constraints ...
if (nargin == 1),
    if (nargout >= 1),
        NProps = length(PB.Properties); S = [];
        for n = 1:NProps,
            Constraints = PB.Properties(n).constraints;
            if isempty(Constraints), S = setfield(S, PB.Properties(n).name, cell(0));
            elseif isstruct(Constraints),    
                idx = find(strcmpi({Constraints.class}, 'char') & ~cellfun('isempty', {Constraints.range}));
                if isempty(idx), S = setfield(S, PB.Properties(n).name, cell(0));
                else, S = setfield(S, PB.Properties(n).name, cat(2, Constraints(idx).range)); end
            else, S = setfield(S, PB.Properties(n).name, Constraints); end %Function handle or character string ...
        end
        PB = S;
    else, disp(PB, 'propconstraints'); clear('PB'); end
%Return or display constraints on requested property ...
elseif (nargin == 2) & ~isstruct(varargin{1}),
    idx = findProperty(PB, varargin{1});
    if isempty(idx), error(sprintf('Property ''%s'' is not in property bag.', varargin{1}));
    elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', varargin{1})); end
    Constraints = PB.Properties(idx).constraints;
    
    if (nargout >= 1),
        if isempty(Constraints), PB = cell(0);
        elseif isstruct(Constraints),    
            idx = find(strcmpi({Constraints.class}, 'char') & ~cellfun('isempty', {Constraints.range}));
            if isempty(idx), PB = cell(0);
            else, PB = cat(2, Constraints(idx).range); end
        else, PB = Constraints; end %Function handle or character string ...
    else, disp(Constraints2Str(Constraints)); clear('PB'); end
%Set values of properties in property bag ...
else,
    %Check for 'norelations' flag ...
    if (nargin > 2) & iscellstr(varargin(1:2)) & strcmpi(varargin{1}, 'norelations'),
        RelationCheck = logical(0); PropList = varargin(2:end);
    else, RelationCheck = logical(1); PropList = varargin; end    
    
    %Expand all structures and cell-array pairs in the argument list.
    %Attention! Structures can never be the value of a property because
    %of this procedure ...
    idx = find(cellfun('isclass', PropList, 'struct')); NStruct = length(idx);
    if any(cellfun('length', PropList(idx)) > 1), 
        error('Only scalar structures can be used to supply properties.'); 
    end
    ExpandedPropList = PropList(1:min([idx-1, end]));
    for n = 1:NStruct,
        Sidx = idx(n); Bidx = Sidx+1;
        if length(idx) >= (n+1), Eidx = idx(n+1)-1; else, Eidx = length(PropList); end
        ExpandedPropList = [ExpandedPropList, Struct2PropList(PropList{Sidx}), PropList(Bidx:Eidx)]; 
    end
    PropList = ExpandedPropList;
    
    idx = find(cellfun('isclass', PropList, 'cell')); 
    if ~isempty(idx), idx = idx(find(diff(idx) == 1)); end; NCells = length(idx);
    ExpandedPropList = PropList(1:min([idx-1, end]));
    for n = 1:NCells,
        Sidx = idx(n); Bidx = Sidx+2;
        if length(idx) >= (n+1), Eidx = idx(n+1)-1; else, Eidx = length(PropList); end
        NamesCell = PropList(Sidx);
        ValuesCell = PropList(Sidx+1);
        if ~isequal(length(NamesCell), length(ValuesCell)), error('Size mismatch in property/value cell pair.'); end
        ExpandedPropList = [ExpandedPropList, vectorzip(NamesCell, ValuesCell), PropList(Bidx:Eidx)];
    end
    PropList = ExpandedPropList;
          
    %Check general consistency of resulting property/value list ...
    if mod(length(PropList), 2), error('Invalid input syntax'); 
    else, NProps = length(PropList)/2; end
    PropNames = PropList(1:2:end);
    PropValues = PropList(2:2:end);
    if ~all(cellfun('isclass', PropNames, 'char')), error('Invalid input syntax'); 
    else, PropNames = lower(PropNames); end %Property names are case-insensitive ...
    
    %Runthrough property/value list and for each property set the value in
    %the property bag to the requested value, check the constraints on the
    %value and if necessary execute relation function corresponding with
    %this property on the property bag ...
    for n = 1:NProps,
        idx = findProperty(PB, PropNames{n});
        if isempty(idx), error(sprintf('Property ''%s'' is not in property bag.', PropNames{n}));
        elseif (length(idx) > 1), error(sprintf('Name of property ''%s'' is ambiguous.', PropNames{n})); 
        else, Name = PB.Properties(idx).name; end
        
        PB.Properties(idx).value = PropValues{n};
        if ~isValidPropertyValue(PB, Name), error(sprintf('Value for property ''%s'' isn''t compatible with constraint.', Name)); end
        
        if RelationCheck,
            idx = findRelation(PB, Name);
            if ~isempty(idx), PB = feval(PB.Relations(idx).function, PB, Name, 'relation'); end
        end
    end    
end