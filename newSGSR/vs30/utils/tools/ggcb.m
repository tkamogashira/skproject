function ggcallback(n,cbstring);
if nargin<1, n = 0; end;
if nargin<2,
   gget(n,'callback');
else,
   ggset(n, 'callback', cbstring);
end

