function closeStimMenu(hdep);
% generic closereq function for stimulus menu

global StimMenuStatus
persistent Dependents
if isempty(Dependents), Dependents = []; end

if ~stimMenuActive,
   warning('cannot find stimmenu');
   return; 
end
hs = StimMenuHandles;
MenuHandle = hs.Root;

if (nargin>0), 
   if ~isempty(hdep), % (backward compatibility)
      % this call does not serve to clsoe the stim menu ...
      % ... but only to declare dependent handles, i.e. figures that should ...
      % ... be deleted with the current figures
      Dependents = localAddDep(Dependents, hdep); % handles must  exist now or ...
      return;                          % ... else won't be accepted as dependents
   end
end

% check if stim menu MAY be closed at all
StopEnable = get(hs.CloseButton, 'enable');
if ~isequal(StopEnable, 'on'), return; end

if StimMenuStatus.paramsOK, SaveMenuDefaults; end;

% clean Dependents (throw away non-existing handles)
try,
   Dependents = localAddDep(Dependents, []);
   close(Dependents); % if dependents have their own closereq functions, these wil be called
end % try
delete(MenuHandle); % returns control to initXXmenu

%------------locals--------------
function dep = localAddDep(dep, hnew);
% add new handle
dep = unique([dep hnew]);
% remove non-existing handles
dep = dep(find(ishandle(dep)));