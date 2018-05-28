function handleStruct = CollectMenuHandles(MenuName, figh)
% CollectMenuHandles - get handles of a figure's children and store handles in struct

% collect handles of children
shh = get(0,'showhiddenhandles'); 
set(0,'showhiddenhandles', 'off'); 
hh = findobj(figh); hh = hh(2:end).'; % row vector; exclude figure itself
set(0,'showhiddenhandles', shh); 

handleStruct.Root = figh;

% use tags as field names to store handles
for h=hh,
   tag = get(h, 'tag');
   tag = trimspace(tag);
   if isvarname(tag), 
      handleStruct = setfield(handleStruct, tag, h);
   end
   % look for special message handles - make them globally known
   if isequal('messagetext', lower(tag)),
      AddToUImessStack(h);
   elseif isequal('reporttext', lower(tag)),
      AddToUImessStack(h);
   end
end

if ~isempty(MenuName),
   % retrieve name of global menu status variable
   MSname = MenuStatusName(MenuName);
   eval(['global ' MSname ';']);
   % now insert this handleStruct in menu status.handles
   eval([MSname '.handles = handleStruct;']);
end


