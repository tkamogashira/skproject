function [x, Name]=ReconstructVar(Syntax, Data);

% initialization of locals (load Data and structList)
local_GetNextDatum(0, Data);
local_constructVar(0, Syntax.structList);

Name = Syntax.name;
x = local_constructVar(Syntax);



%------------------locals---------------
function nextd = local_GetNextDatum(DatumClass, d);
persistent Pos Data
if isequal(0,DatumClass), % rewind and store Data
   Data = d;
   fns = fieldnames(Data);
   for ii=1:length(fns),
      fn = fns{ii};
      eval(['Pos.' fn '=0;']);
   end
   return;
end
% retrieve size and update size pointer
S = Data.sizes(Pos.sizes+(1:2));
if S(1)<0, % ndim>2 (see syntaxOf)
   Ndim = -S(1);
   S = Data.sizes(Pos.sizes+1+(1:Ndim));
   Pos.sizes = Pos.sizes + 1 + Ndim;
else,
   Pos.sizes = Pos.sizes + 2;
end
% arrays of non-elementary classes: only size is stored; no data
% so return size and quit
if ~isfield(Data, DatumClass),
   nextd = S;
   return
end
Nelem = prod(S); % number of elements to be read
Offset = getfield(Pos, DatumClass);
startpos = Offset+1;
endpos = Offset+Nelem;
% now read teh elements from d.<DatumClass> and update pointer
eval(['nextd = Data.' DatumClass '(startpos:endpos);']);
eval(['Pos.' DatumClass ' = ' 'Pos.' DatumClass ' + Nelem;']);
% finally restore the dimensions
nextd = reshape(nextd, S);

function s = local_InitStruct(fns);
for ii = 1:length(fns),
   eval(['s(1).' fns{ii} ' = [];']);
end

function y = local_constructVar(sy, sList);
persistent structList
if isequal(0,sy), % initialization: store structList
   structList = sList;
   return;
end
switch sy.class
case 'struct',
   fns = structList{sy.istruct}; % the field names in correct order
   y = local_InitStruct(fns); % empty struct with correct field names
   for ii=1:length(fns), % recursive call to fill the fields
      y = setfield(y,fns{ii}, local_constructVar(sy.elements(ii)));
   end
case 'structarray',
   fns = structList{sy.istruct}; % the field names in correct order
   y = local_InitStruct(fns); % empty struct with correct field names
   for ii=1:length(sy.elements), % recursive call to fill the array elements
      y(ii) = local_constructVar(sy.elements(ii));
   end
   % now get size, which is stored in data for structarrays
   ysize = local_GetNextDatum(sy.class);
   y = reshape(y,ysize);
case 'cell',
   N = length(sy.elements); % number of cells
   y = cell(1, prod(sy.size));
   for ii=1:N,
      y{ii} = local_constructVar(sy.elements(ii));
   end
   y = reshape(y,sy.size); % restore original ordering of elements
case {'double', 'char', 'uint8'}, % primitive data - get them
   y = local_GetNextDatum(sy.class);
otherwise,
   error(['don''t know how to reconstruct class ''' xclass ''' variables']);
end










