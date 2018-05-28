function uiparamedit(Prefix,PromptStr, EditStr, UnitStr);

hh = uipaste(0,'XXXparamEdit');
for ii=1:length(hh),
   h = hh(ii);
   tag = get(h,'tag');
   tag = [Prefix tag];
   set(h,'tag',tag);
   uigroup.tags{ii} = tag;
end


if nargin>1, 
   setstring(hh(3), PromptStr); 
   local_rightResize(hh(3));
end;
if nargin>2, 
   setstring(hh(2), EditStr); 
   xmoveEdit = local_leftResize(hh(2));
end;
if nargin>3, 
   setstring(hh(1), UnitStr);
   local_leftResize(hh(1), xmoveEdit);
end;

function rightEdgeMove = local_leftResize(h,extraXmove);
if nargin<2, extraXmove = 0; end;
pos = get(h,'position');
ext = get(h,'extent');
isEdit = isequal(get(h,'Style'),'edit');
if isEdit, ext(3)=ext(3)+10; end;
set(h, 'position',[pos(1)+extraXmove pos(2) ext(3) pos(4)]);
newpos = get(h,'position');
rightEdgeMove = newpos(1)+newpos(3)-(pos(1)+pos(3));

function leftEdgeMove = local_rightResize(h,extraXmove);
if nargin<2, extraXmove = 0; end;
pos = get(h,'position');
ext = get(h,'extent');
xmove = pos(3)-ext(3) + extraXmove;
set(h, 'position',[pos(1)+xmove pos(2) ext(3) ext(4)]);
newpos = get(h,'position');
leftEdgeMove = newpos(1)-pos(1);