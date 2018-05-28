function repaint(figh);
% REPAINT - set visibility of figure or uicontrol off and on again to force repainting
if nargin<1,
   figh = get(0,'currentfigure'); 
   if isequal('off',get(figh,'visible')),
      return;
   end
end
if isempty(figh), return ; end;
set(figh,'visible','off');
drawnow;
set(figh,'visible','on');
drawnow;
