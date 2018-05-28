function ggHor(n, R);

global GG;
if nargin<2, R = 0; end;

   
   if R==0, set(GG(n), 'horizontalal', 'left');
   else set(GG(n), 'horizontalal', 'righ');
   end
   

   
