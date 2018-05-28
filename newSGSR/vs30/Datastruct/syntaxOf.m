function [y, d]=syntaxOf(x, storeData,RecursiveCall, structIndex);

% size should be part of data, not syntax (at least if we're dealing with true arrays, not cell arrays)
% hash numbers, also for substructures
% write reassemble function!


if nargin<2, storeData = 0; end;
if nargin<3, RecursiveCall=0; end;
if nargin<4, structIndex = 0; end;
storeData = (nargout>1) & storeData;

persistent StructList
if ~RecursiveCall, % initialize list of struct field names
   StructList = {};
end


w = whos('x');
emptyStruct = struct('size',[],'istruct',[],'class',[], 'elements',[]);
y = emptyStruct;
y.class = w.class;
y.elements = []; % no data, only syntax

emptyDataStruct = struct('sizes',[],'double',[],'char','','uint8',[]);
d = emptyDataStruct;
% simplify the visiting of all matrix elements (the original order can be retrieved from size)
xclass = class(x);
LenX = length(x);

switch xclass
case 'struct',
   fns = fieldnames(x);
   xsize = local_encodeSize(size(x));
   x = x(:); % simplify the visting of all elements
   if ~isempty(x), y.elements = emptyStruct; end;
   if structIndex==0, % structure index not known - lookup in StructList
      [StructList, y.istruct] = local_StoreStruct(StructList, fns);
   else,
      y.istruct = structIndex; % passed by calling function - no need for lookup
   end
   N = length(fns);
   if (LenX==1),
      for ii=1:N, % each element of y is one field of x
         fn = fns{ii};
         fieldVal= getfield(x,fn);
         [y.elements(ii), dd] = syntaxOf(fieldVal, storeData,1);
         d = local_MergeData(d,dd);
      end
   elseif (LenX>1),
      y.class = 'structarray';
      for ii=1:LenX, % each element of y is one subscripted element of x
         indivVal = x(ii);
         [y.elements(ii) dd] = syntaxOf(indivVal, storeData,1, y.istruct);
         d = local_MergeData(d,dd);
      end
      % we have stored the *elements* of x only, now also store the size of x ind
      if storeData,
         dd = emptyDataStruct;
         dd.sizes = xsize;
         d = local_MergeData(d,dd); 
      end;
   end
case 'cell',
   N = length(x);
   y.size = size(x); % for cell arrays, size belongs to syntax , not data
   x = x(:); % simplify visiting all elements; size is stored to reshape
   y.elements = emptyStruct;
   for ii=1:N, % each element of y is one cell of x
      indivVal = x{ii};
      [y.elements(ii) dd] = syntaxOf(indivVal, storeData,1);
      d = local_MergeData(d,dd);
   end
case {'double', 'char', 'uint8'},
   if storeData, 
      d.sizes = size(x);
      d = setfield(d,xclass,x(:).'); % always store as row vector
   end;
otherwise,
   error(['don''t know how to parse class ''' xclass ''' variables']);
end

if ~RecursiveCall, % store name and structlist
   y.name = inputname(1);
   y.structList = StructList;
end

%-------locals----------
function d = local_MergeData(d,dd);
if isempty(dd), return; end;
fns = fieldnames(d);
N = length(fns);
for ii=1:N,
   fn = fns{ii};
   d = setfield(d, fn, [getfield(d,fn), getfield(dd,fn)]);
end

function es = local_encodeSize(s);
% prepend -length(size) if size is abnormal, i.e., contains more then 2 dimensions
N = length(s);
if length(s)<3, es = s; 
else, es = [-N, s];
end

function [Slist, SlistIndex] = local_StoreStruct(Slist, Fnames);
% first look if Fnames collection already exist in Slist
Nlist = length(Slist);
SlistIndex = 0;
for ii=1:Nlist
   if isequal(Fnames, Slist{ii}), SlistIndex = ii; break; end;
end
% if it is new, add it to the list and return the new index
if SlistIndex ==0,
   SlistIndex = Nlist+1;
   Slist{SlistIndex} = Fnames;
end







