function ReconstructMenu(SubUnits);

global VERSIONDIR

if nargin<1,
   SUfile = uigetfile([VERSIONDIR '\stimmenu\construction\*.org']);
   if SUfile==0, return; end; % user cancelled
   qq= load(SUfile,'-mat');
   SubUnits = qq.SU;
elseif ischar(SubUnits),
   SUfile = [VERSIONDIR '\stimmenu\construction\' SubUnits 'Menu.org']
   qq= load(SUfile,'-mat');
   SubUnits = qq.SU;
end

N = length(SubUnits);

more off;
figh = figure
set(figh,'visible','off'); % avoid flickering, etc, during construction.

for ii=N:-1:1,
   Unit = SubUnits{ii};
   if isfield(Unit, 'Props'), % this unit is a collection of figure properties
      set(figh, Unit.Props);
   else, % a uicontrol group
      disp('-----------');
      fn = RemoveFileExtension(Unit.filename)
      uipaste(0,fn,1,figh);
      % get handle of anchor control
      ah = findobj(figh, 'tag', Unit.anchor);
      if length(ah)~=1,
         error(['handle size is ' num2str(length(ah)) '(' Unit.anchor ')']);
      end
      % get position of anchor
      disp(['anchor uicontrol: ' Unit.anchor]);
      anchorPos = get(ah, 'position')
      % compare with target position
      kick = Unit.anchorPos - anchorPos;
      % collect handles of all tags of this group
      Ntag = length(Unit.tags)
      ToMoveH = zeros(1,Ntag);
      for itag = 1:Ntag,
         disp(Unit.tags{itag})
         TMH = findobj(figh, 'tag', Unit.tags{itag})
         ToMoveH(itag) = TMH;
      end
      % kick all controls to right position
      for itag = 1:Ntag,
         % check type; menu controls cannot be moved this way
         UItype = lower(get(ToMoveH(itag),'type'));
         if ~isequal(UItype,'uimenu'),
            OldPos = get(ToMoveH(itag),'position');
            NewPos = OldPos + [1 1 0 0].*kick; % leave 3rd&4rth elements alone (size)
            set(ToMoveH(itag),'position',NewPos);
         end
      end
   end
end
% store the SU info in userdata of SessionMenu (which is always present)
UIsetSU(SubUnits,figh);

set(figh,'visible','on'); % avoid flickering, etc, during construction.
more on;