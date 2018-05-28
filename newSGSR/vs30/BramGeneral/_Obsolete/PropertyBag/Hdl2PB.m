function PB = Hdl2PB(Hdl, ExList)
%HDL2PB  convert graphics handle to property bag.
%   PB = HDL2PB(Hdl) convert the handle of a MATLAB handle graphics
%   object to a property bag object. The properties, initial values and
%   character string range constraints are taken into account. Possible
%   constraints on other properties or relations between properties must
%   be added manually.
%
%   PB = HDL2PB(Hdl, ExList) where a cell-array of strings is given with
%   names of properties for which extraction of constraints isn't 
%   necessary.

%B. Van de Sande 13-05-2004

%Checking input arguments ...
if (nargin ~= [1, 2]), error('Wrong number of input arguments.'); end
if ~ishandle(Hdl), error('First argument should be valid handle.'); end
if (nargin == 1), ExList = cell(0);
elseif ~iscellstr(ExList) & ~ischar(ExList), error('Second argument shoul be cell-array of property names.'); end 

%The GET command on handle graphics results in information on properties
%and their values ...
S1 = get(Hdl); FN1 = fieldnames(S1); Value = struct2cell(S1);
%STRUCT creates structure-array ...
Properties = struct('name', FN1, 'constraints', [], 'value', Value);

%The SET command on handle graphics results in information on constraints
%on properties with characters strings as values with a finite set of possibilities ...
S2 = set(Hdl); FN2 = fieldnames(S2); Range = struct2cell(S2); 
idx = find(~cellfun('isempty', Range) & ~ismember(lower(FN2), lower(ExList))); [FN2, Range] = deal(FN2(idx), Range(idx));
NFields = length(FN2);
for n = 1:NFields,
    idx = ismember(FN1, FN2{n});
    if ~isempty(idx) & (length(Range{n}) ~= 1),
        Properties(idx).constraints = struct('class', 'char', 'dimensions', [], 'range', Range(n));
    end    
end

%Creating property bag ...
PB = PropertyBag;
PB = Add(PB, Properties);