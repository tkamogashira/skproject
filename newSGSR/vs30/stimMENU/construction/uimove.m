function uimove(groupNr, dx,dy, figh);

% moves subunit
if nargin<3, dy = 0; end;
if nargin<4, figh=gcf; end;

Ngr = length(groupNr);
if Ngr>1, % recursive call
   for ii=1:Ngr,
      uimove(groupNr(ii),dx,dy,figh);
   end
   return;
end

% get subunits
SU = uigetSU(figh);
% select the one to move
Unit = SU{groupNr};
% visit tags and move them
if ~isfield(Unit,'filename'),
   error('not a moveable subunit');
end
Tags = Unit.tags;
Ntags = length(Tags);
for itag=1:Ntags,
   h = findobj(figh,'tag',Tags{itag});
   if ~ishandle(h),
      warning(['cannot find uicontrol ''' Tags{itag} '''']);
   else,
      oldPos = get(h,'position');
      if length(oldPos)==4,
         newPos = oldPos + [dx dy 0 0];
      else, % menu
         newPos = oldPos + dx;
      end
      try, set(h,'position',newPos); end;
   end
end
