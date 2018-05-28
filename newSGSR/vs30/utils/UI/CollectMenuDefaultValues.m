function defVal = CollectMenuDefaultValues(MenuName);

MS = CopyOfMenuStatus(MenuName);

% if no defaults were declared, quit
if ~isfield(MS,'defaults'), 
   defVal = [];
   return; 
end;
defVal = MS.defaults; % struct array containing all tag/prop values & empty value fields

% visit controls and collect values
nn = length(defVal);
for ii = 1:nn,
   % get handle of uicontrol
   h = getfield(MS.handles, defVal(ii).tag);
   % retrieve value of desired property
   value = get(h, defVal(ii).prop);
	defVal(ii).value = value;
end


