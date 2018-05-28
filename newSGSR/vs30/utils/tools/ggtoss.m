function ggtoss(h,n,m);

global GG;

ch = get(h,'children');
% counting from 2 in GG ~ counting from 1 in ch
n = n-1; m = m-1;
if m==n, return; end;
mover = ch(n);
ch(n) = [];
if m>n,
   ch = [ch(1:(m-2)); mover; ch((m-1):end)];
else
   ch = [ch(1:(m-1)); mover; ch(m:end)];
end
set(h,'children',ch);
rget(h);

   
