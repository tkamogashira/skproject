function Pn = dpoisson(a, n);
% dpoisson - poisson distr (inefficient algorithm)
if length(n)>1,
   Pn = 0+n;
   for ii=1:prod(size(n)),
      Pn(ii) = dpoisson(a,n(ii));
   end
   return;
end
Pn = exp(-a)*prod(a./(1:n));
