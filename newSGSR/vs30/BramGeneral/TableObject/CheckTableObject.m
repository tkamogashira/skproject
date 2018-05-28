function boolean = CheckTableObject(TableObject)

boolean = logical(1);

ID      = 'ListFile';
Version = 1;

if ~isa(TableObject, 'struct') | ~isfield(TableObject, 'Header') |  ...
   ~isfield(TableObject.Header, 'ID') | ~isfield(TableObject.Header, 'Version') | ...
   ~strcmp(TableObject.Header.ID, ID) | (TableObject.Header.Version ~= Version)
    boolean = logical(0); return;
end
