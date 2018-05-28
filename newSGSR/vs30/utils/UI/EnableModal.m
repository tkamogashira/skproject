function EnableModal(enab);
% enableModal - manipulate modal window visibility
%    enableModal(0) sets 'visible' prop of all modal windows to 'off'
%    enableModal(1) sets 'visible' prop of all modal windows to 'on'
%
%    order is chosen so that the highest figure number will be the 
%    current one after enabling
set(0,'showhiddenhandles','on');
mch = sort(findobj('windowstyle','modal'));

for h=mch,
   if enab, set(h, 'visible', 'on');
   else,    set(h, 'visible', 'off');
   end
end
