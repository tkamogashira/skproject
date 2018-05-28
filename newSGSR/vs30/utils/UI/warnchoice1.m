function pushed = warnchoice1(Title, SubTitle, Prompt, b1, b2, b3);

if nargin<5, b2 = ''; end;
if nargin<6, b3 = ''; end;

   
% parse prompt
if ~isempty(Prompt) & ~(size(Prompt,1)>1),
   delim = Prompt(1);
   PP = [];
   while 1,
      [line Prompt] = strtok(Prompt, delim);
      PP = strvcat(PP, line);
      if isempty(Prompt), break; end;
   end
else, PP = Prompt;
end;
[h sth] = initwarnchoice1(Title, SubTitle, PP, b1, b2, b3);

repaint(h);
waitfor(sth); % subtitle  is deleted by pushing a button (see warnchoice1push)
pushed = get(h, 'userdata');
delete(h);

