function y = ggretag(n, oldPrefix, newPrefix, newPrompt, newUnit);

global GG;
Lold = length(oldPrefix);
% check old tags
for ii=n,
   ot = get(GG(ii),'tag');
   if ~isequal(oldPrefix,ot(1:Lold)),
      error(['Old-prefix mismatch']);
   end
end
% rename tags
for ii=n,
   h = GG(ii);
   ot = get(h,'tag');
   nt = [newPrefix, ot(Lold+1:end)];
   set(h,'tag', nt);
   if nargin>=4,
      if strEndsWith(ot, 'Prompt'),
         setstring(h,newPrompt);
         ggfit(ii);
         ggtool(ii,'');
      elseif strEndsWith(ot, 'Unit') & nargin>=5,
         setstring(h,newUnit);
         ggfit(ii);
      end
   end
end
   
