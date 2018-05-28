function uipromptedbutton(Prefix,PromptStr, ButStr);

hh = uipaste(0,'PromptedButton',1);
for ii=1:length(hh),
   h = hh(ii);
   tag = get(h,'tag');
   tag = [Prefix tag];
   set(h,'tag',tag);
   uigroup.tags{ii} = tag;
end



if nargin>1, setstring(hh(2), PromptStr); end;
if nargin>2, setstring(hh(1), ButStr); end;


