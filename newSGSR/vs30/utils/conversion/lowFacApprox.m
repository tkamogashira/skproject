function [m, fm]=lowFacApprox(n,lp);
% lowFacApprox - approximates number by a product of small primes
%    returns best approx in terms of rel deviation (factor)
%    usefull for faster FFTs when exact #samepls is inumportant

persistent Had

if ~isempty(Had),
   yep = find(Had(1,:)==n+i*lp);
   if ~isempty(yep),
      m = Had(2,min(yep));
      fm = factor(m);
      return
   end
else,
   Had = [];
end


if nargin<2, lp = 5; end % largest prime
PP = primes(lp);
minF = sqrt(PP(end)/(PP(end)-1));
TTup   =   n:round(n*minF);
TTdown =   n-1:-1:round(n/minF);
mup = inf;
for t=TTup,
   if all(factor(t)<=lp), 
      mup = t;
      break
   end
end
rf = mup/n;
mdown = 1e-70;
for t=TTdown,
   if all(factor(t)<=lp), 
      mdown = t;
      break
   end
   if n/t>rf, break; end
end

if n^2>mdown*mup, m = mup;
else, m = mdown;
end
fm = factor(m);
Had = [Had, [n+i*lp; m]];




