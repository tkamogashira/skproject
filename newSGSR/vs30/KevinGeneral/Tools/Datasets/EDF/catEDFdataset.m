function EDFdsArray = catEDFdataset(Dim, varargin)

%B. Van de Sande 07-08-2003

if nargin == 1, EDFdsArray = []; return; end

%Array of EDF datasets can only be made from datasets with the same schema name ...
SchName = ''; Buffer = {};
for n = 1:(nargin-1),
   if ~isempty(varargin{n}),
      SN = varargin{n}(1).SchName;
      if isempty(SchName), SchName = SN; end
      if ~strcmp(SchName, SN), error('Cannot concatenate datasets having different schemata.'); end;
      Buffer = {Buffer{:} varargin{n}};
   end
end

EDFdsArray = builtin('cat', Dim, Buffer{:});