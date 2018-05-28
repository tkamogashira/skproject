function boolean = isdbfield(DBFields, DBFieldName)

%B. Van de Sande 28-03-2003

if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~isstruct(DBFields) | ~isfield(DBFields, 'SuperField') | ~isfield(DBFields, 'SubFields'), error('First argument should be structure with DB-fieldnames.'); end
if iscellstr(DBFieldName), 
    N = length(DBFieldName); boolean = repmat(logical(0), 1, N);
    for n = 1:N, boolean(n) = isdbfield(DBFields, DBFieldName{n}); end
    return;
elseif ~ischar(DBFieldName), error('Second argument should be character string with name of DB-field.'); end

Tokens = Words2Cell(DBFieldName, '.');
if (length(Tokens) ~= 2), boolean = logical(0); end
SuperField = Tokens{1};
SubField   = Tokens{2};

idx = find(ismember({DBFields.SuperField}, SuperField));
if isempty(idx), boolean = logical(0); end
SubFields = DBFields(idx).SubFields;

if ismember(SubField, SubFields), boolean = logical(1);
else boolean = logical(0); end
