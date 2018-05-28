function MarkBuffer(bname,doDelete)
% MarkBuffer - mark global buffer variable for deletion or (2nd arg) delete the list

if nargin<2, doDelete=0; end;

global MarkedBufferList
if ~doDelete, % add bname to list of buffers
   if isempty(MarkedBufferList), MarkedBufferList = {}; end;
   % check if bname is already in list
   for ii=1:length(MarkedBufferList),
      if isequal(bname, MarkedBufferList{ii}), return; end; % already in list -> quit
   end
   % bname is new -> append it to list
   MarkedBufferList = {MarkedBufferList{:}, bname};
else, % empty (not delete) all members of list and empty the list
   for ii=1:length(MarkedBufferList),
      try ,
         bufname = MarkedBufferList{ii};
         eval(['global ' bufname]); 
         eval([bufname ' = [];']);
      % catch, lasterr
      end
   end
   MarkedBufferList = {};
end
