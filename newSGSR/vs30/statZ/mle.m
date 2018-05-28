function [phat, pci] = mle(dist,data,alpha,p1)
%MLE    Maximum likelihood estimation.
%   PHAT = MLE(DIST,DATA) Returns the maximum likelihood estimates
%   for the distribution specified in DIST using the sample in the
%   vector, DATA.
%   
%   [PHAT, PCI] = MLE(DIST,DATA,ALPHA,P1) Returns the MLEs and 
%   100(1-ALPHA) percent confidence intervals given the data.
%   ALPHA is optional. By default ALPHA = 0.05 which corresponds
%   to 95% confidence intervals. P1 is an extra parameter for use
%   with the binomial distribution for supplying the number of trials.

%   B.A. Jones 1-27-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:50 $

if ~isstr(dist), 
    error('First argument must be a distribution name.'); 
end

if nargin < 3 
   alpha = 0.05;
end

if nargin == 4 & isempty(alpha)
   alpha = 0.05;
end

[m,n] = size(data);
if min(m,n) > 1,
   error('Requires a vector second input argument.');
end

n = max(m,n);
data = data(:);
p_int = [alpha/2; 1-alpha/2];

if strcmp(dist,'beta') | strcmp(dist,'Beta'),  
   tmp1 = prod((1-data) .^ (1./n));
   tmp2 = prod(data .^ (1./n));
   tmp3 = (1 - tmp1 - tmp2);
   a = 0.5*(1-tmp1) ./ tmp3;
   b = 0.5*(1-tmp2) ./ tmp3;
   phat = fmins('betalike',[a b],[],[],data);
   [logL,info]=betalike(phat,data);
   sigma = sqrt(diag(info));
   pci = norminv([p_int p_int],[phat; phat],[sigma';sigma']);


elseif strcmp(dist,'Bernoulli') | strcmp(dist,'bernoulli'),  
   phat = mean(data);
   k = find(data ~= 1 & data ~= 0);
   if any(k)
      error('Bernoulli data must either be 1 or 0.');
   end
   x = sum(data);

   nu1 = 2*x;
   nu2 = 2*(n-x+1);
   F   = finv(alpha/2,nu1,nu2);
   lb  = (nu1.*F)./(nu2 + nu1.*F);
   
   nu1 = 2*(x+1);
   nu2 = 2*(n-x);
   F   = finv(1-alpha/2,nu1,nu2);
   ub = (nu1.*F)./(nu2 + nu1.*F);
   pci = [lb; ub];

elseif strcmp(dist,'bino') | strcmp(dist,'binomial'),
   N = p1(:);  
   phat = (data./N)';

   nu1 = 2*data';
   nu2 = 2*(N - data +1)';
   F   = finv(alpha/2,nu1,nu2);
   lb  = (nu1.*F)./(nu2 + nu1.*F);
   
   nu1 = 2*(data+1)';
   nu2 = 2*(N - data)';
   F   = finv(1-alpha/2,nu1,nu2);
   ub = (nu1.*F)./(nu2 + nu1.*F);
   pci = [lb; ub];

elseif strcmp(dist,'exp') | strcmp(dist,'Exponential'),   
   phat = mean(data);
   pci  = gaminv(p_int,[n; n],[phat; phat])./n;

elseif strcmp(dist,'gam') | strcmp(dist,'Gamma'),
   b = var(data)./mean(data);
   a = mean(data)./b;
   phat = fmins('gamlike',[a b],[],[],data);
   [logL,info]=gamlike(phat,data);
   sigma = sqrt(diag(info));
   pci = norminv([p_int p_int],[phat; phat],[sigma';sigma']);

elseif strcmp(dist,'geo') | strcmp(dist,'Geometric'),   
   sumx = sum(data);
   phat = sumx./n;
    pci = nbininv(p_int,[n; n],[phat; phat])./n;

elseif strcmp(dist,'norm') | strcmp(dist,'Normal') | strcmp(dist,'normal'),
    ff = sqrt((n-1)/n);
    phat = [mean(data) std(data)*ff];
   [logL,info]=normlike(phat,data);
    sigma = sqrt(diag(info));
    pci = norminv([p_int p_int],[phat; phat],[sigma';sigma']);


elseif strcmp(dist,'poiss') | strcmp(dist,'Poisson'),
   phat = mean(data);
   lsum = n*phat;

   if lsum >= 100;
       pci = norminv([alpha/2; 1-alpha/2],lsum,sqrt(lsum));
   else
       pci = poissinv([alpha/2; 1-alpha/2],lsum);
    end

elseif strcmp(dist,'unid') | strcmp(dist,'Discrete Uniform'),  
   phat = max(data);
   pci = [phat; ceil(phat./alpha.^(1./n))];

elseif strcmp(dist,'unif')  | strcmp(dist,'Uniform'),  
   phat = [min(data) max(data)];
   upper = phat(1) + (phat(2)-phat(1))./alpha.^(1./n);
   lower = phat(2) - (phat(2)-phat(1))./alpha.^(1./n);
   pci = [lower phat(2);phat(1) upper];

elseif strcmp(dist,'weib') | strcmp(dist,'Weibull'),  
   eprob = [0.5./n:1./n:(n - 0.5)./n]';
   w  = log(log(1./(1-eprob)));
   z  = sort(log(data));
   c  = polyfit(z,w,1);
   a  = exp(c(2)/c(1));
   b  = c(1);
   phat = fmins('weiblike',[a b],[],[],data);
   [logL,info]=weiblike(phat,data);
   sigma = sqrt(diag(info));
   pci = norminv([p_int p_int],[phat; phat],[sigma';sigma']);
else   
    error('Sorry, MLE cannot estimate parameters from this distribution.'); 
end
