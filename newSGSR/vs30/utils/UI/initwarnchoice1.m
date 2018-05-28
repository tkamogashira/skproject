function [h, sth]=initwarnchoice1(Title, SubTitle, Prompt, B1, B2, B3);

open warnchoice1.fig;
h = gcf;
set(h,'windowstyle','modal');
sth = findobj(h,'tag', 'SubTitle');
prh = findobj(h,'tag', 'Prompt');
b1h = findobj(h,'tag', 'Pushbutton1');
b2h = findobj(h,'tag', 'Pushbutton2');
b3h = findobj(h,'tag', 'Pushbutton3');

set(h, 'name', Title);
set(sth, 'string', SubTitle);
set(prh, 'string', Prompt);
if isempty(B1),
   set(b1h, 'visible', 'off');
else,
   set(b1h, 'string', B1);
end

if isempty(B2),
   set(b2h, 'visible', 'off');
else,
   set(b2h, 'string', B2);
end

if isempty(B3),
   set(b3h, 'visible', 'off');
else,
   set(b3h, 'string', B3);
end

