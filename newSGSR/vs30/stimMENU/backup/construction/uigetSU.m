function SU = uigetSU(figh);

if nargin<1, figh=gcf; end;

SU = get(figh, 'userdata');
if isempty(SU) | ~iscell(SU), % try to retrieve from session menu (obsolete)
   SMh = findobj(figh,'tag','SessionMenu');
   if ~ishandle(SMh), 
      warning('no session menu handle found');
      return;
   end
   SU = get(SMh,'userdata');
end
if ~iscell(SU), SU = []; end;


