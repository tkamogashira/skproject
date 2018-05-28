function UItextColor(hh, color, EditsOnly);
if nargin<3, EditsOnly=0; end;

doit = 1;
for h = hh,
   doit = isequal(get(h,'type'),'uicontrol');
   if (EditsOnly&doit), doit = doit & isequal(get(h,'style'),'edit'); end;
      if ishandle(h) & doit, 
         set(h,'foregroundcolor',color); 
      end;
end


