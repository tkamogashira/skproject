function repaintWait(figh);
% REPAINTWAIT - wait for figure to be deleted; repaint when moved
%  This is to fix a bug in the openGL renderer, which causes
%  parts of a figure to be wiped out when moved from behind
%  the screen limits.

if ~ishandle(figh),
   return;
end
if ~isequal(get(figh,'type'),'figure'),
   error('Input arg must be figure handle.');
end
repaint(figh);

while ishandle(figh),
   waitfor(figh,'position');
   if ~ishandle(figh), break; end;
   % switch visibility off & on to force repainting the figure
   repaint(figh);
end
