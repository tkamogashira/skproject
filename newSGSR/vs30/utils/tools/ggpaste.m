function ggpaste(Cop, figh);

if nargin<2, figh=gcf; end;

if iscell(Cop), % reverse order
   for ii=length(Cop):-1:1,
      ggpaste(Cop{ii}, figh);
   end
else,
   if ~isfield(Cop,'Type'), Cop.Type='uicontrol';end;
   if isequal(Cop.Type,'uicontrol'),
      Cop = RmField(Cop,'Type');
      uicontrol(figh, Cop);
   elseif isequal(Cop.Type,'uimenu'),
      Cop = RmField(Cop,'Type');
      Cop = RmField(Cop,'Position');
      Items = Cop.Children;
      Cop = RmField(Cop,'Children');
      hh=uimenu(figh, Cop);
      for ii=1:length(Items),
         Cop = Items{ii};
         Cop = RmField(Cop,'Type');
         uimenu(hh,Cop);
      end
   end
end
global GG
if ~isempty(GG),
   if isequal(figh,GG(1)),
      rget;
   end
end
