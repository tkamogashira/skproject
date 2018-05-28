function y=MENUbuttonToggle(btnTexts);

persistent DoQuestion
if isempty(DoQuestion),
   DoQuestion = local_ToBeOrNotToBe(0);
end

if nargin>0,
   if isequal(btnTexts,'ResetPersistentQuestion'),
      DoQuestion = local_ToBeOrNotToBe(0);
      return;
   end
end

h= gcbo;
TAG = get(h,'tag');
if isequal(TAG,'QuestionToggleMenuItem'),
   DoQuestion = local_ToBeOrNotToBe(1);
   return;
end

% from here, h belongs to toggle button 
bstr= getstring(h);
n = get(h,'userdata'); % Current value
if DoQuestion,
   setstring(h,'?');
   set(h,'userdata',i*abs(n));
   DoQuestion = local_ToBeOrNotToBe(0);
   return
elseif isequal(bstr,'?') | ~isreal(n),
   set(h,'userdata',abs(n));
   menuButtonMatch(h);
   return
end

Nsel = length(btnTexts);

if ~ismember(n,1:Nsel), n=Nsel; end;
n = 1+rem(n, Nsel);  % new value
set(h,'userdata',n);
set(h,'string',btnTexts{n});
col = get(h,'foregroundcolor');
BLACK = [0 0 0];
if ~isequal(col,BLACK),
   set(h,'foregroundcolor',BLACK);
end
drawnow;

% ----------locals
function question = local_ToBeOrNotToBe(yesno);
question = yesno;
if question,
   set(gcf,'pointer','custom');
   set(gcf,'pointershapeCData',mypointershape('?'));
else,
   set(gcf,'pointer','arrow');
end
