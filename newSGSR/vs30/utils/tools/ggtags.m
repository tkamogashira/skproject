function tl=ggtags(n);
global GG

if nargin<1, n = 0; end;
if n==0, n=1:length(GG); end;

if isstr(n),
   n = lower(n);
   for ii=1:length(GG),
      tag = get(GG(ii), 'tag');
      if ~isempty(findstr(n, lower(tag))),
         disp([num2str(ii) ': ' tag]);
      end
   end
else
   if nargout<1, % prettyprint tag list
      gget(n, 'Tag');
   else,
      tl = gget(n, 'Tag');
   end
end

   
   
