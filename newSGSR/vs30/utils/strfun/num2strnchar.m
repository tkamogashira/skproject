function xs = num2strnchar(x,n);
% num2strnchar - number to string conversion using at most n characters in total XXX unfinished
% utility for printing numbers in plots, etc
% if x is a matrix, the strings returned in a Nxn matrix, where
% the rows correspond to the respective elements of the vector x(:).
% spaces are appended if n is too big for representing x
Nx = prod(size(x));
if Nx>1, % recursive call
   x = x(:);
   xs = char(' ' + zeros(Nx,n));
   for ii=1:Nx,
      xs(ii,:) = num2strnchar(x(ii),n);
   end
   return;
end
% from here only single-values x
if x<0,
   xs = ['-' num2strnchar(x,n-1)];
end
% from here only positive values
if round(x)<(10^n-1) & (x>=1), % no exponent needed
   xs = fixLenStr(num2str(x),n);
   if xs(end)=='.', xs(end) = ' '; end;
elseif (x<1) & (round(x*10^n)>10), % notation 0.123
   
end
