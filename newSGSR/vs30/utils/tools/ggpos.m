function ggpos(n, pos, fromright, fromabove);
if nargin<3, fromright=0; end;
if nargin<4, fromabove=0; end;

global GG;
figure(gcf); %show

if nargin<2,
   gget(n, 'Position');
   return;
end

oldpos = get(GG(n), 'Position');
for ii=1:4,
   if pos(ii)<=0, pos(ii)=oldpos(ii); end; 
end;
set(GG(n), 'Position', pos);

if fromright,
   ggmove(n, oldpos(3)-pos(3));
end
if fromabove,
   ggmove(n, 0, oldpos(4)-pos(4));
end

   
