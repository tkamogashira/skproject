function y = ggtag(n, tag);

global GG;
if nargin<2,
   y = get(GG(n), 'tag');
else,
   set(GG(n), 'tag', tag);
end

   
