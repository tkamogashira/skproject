function pasteToFig(Cop, figh);

if nargin<2, figh=gcf; end;

if iscell(Cop), % reverse order
   for ii=length(Cop):-1:1,
      pasteToFig(Cop{ii}, figh);
   end
else,
   if ~isfield(Cop,'Type'), Cop.Type='uicontrol';end;
   if isequal(Cop.Type,'uicontrol'),
      Cop = RmField(Cop,'Type');
      uicontrol(figh, Cop);
   elseif isequal(Cop.Type,'uimenu'),
      Cop = RmField(Cop,'Type');
      Items = Cop.Children;
      Cop = RmField(Cop,'Children');
      hh=uimenu(figh, Cop);
      for ii=1:length(Items),
         Cop = Items{ii};
         if~isempty(Cop),
            Cop = RmField(Cop,'Type');
            uimenu(hh,Cop);
         end;
      end
   end
end
