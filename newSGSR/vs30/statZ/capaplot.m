function [p, h] = capaplot(data,specs)
%CAPAPLOT Capability plot.
%   CAPAPLOT(DATA,SPECS) fits the observations in the vector DATA assuming a normal
%   distribution with unknown mean and variance and plots the distribution of 
%   a new observation (T distribution.) The part of the distribution between the 
%   lower and upper bounds contained in the two element vector, SPECS, is shaded
%   in the plot.
%
%   [P, H] = CAPAPLOT(DATA,SPECS) returns the probability of the new observation
%   being within spec in P and handles to the plot elements in H.

%   B.A. Jones 2-14-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1998/05/28 20:13:55 $

if prod(size(specs)) ~= 2,
   error('Requires the second input to be a two element vector.');
end

lb = specs(1);
ub = specs(2);
if lb > ub
  lb = specs(2);
  ub = specs(1);
end

if lb == -Inf & ub == Inf
   error('The vector of specifications must have at least one finite element');
end

[m,n] = size(data);
if min(m,n) ~= 1
   error('First argument has to be a vector.');
end

if m == 1
   m = n;
   data = data(:);
end

mu = mean(data);
sigma = std(data);

prob = (0.002:0.004:0.998)';

x = mu + tinv(prob,m-1)*sigma;
y = tpdf((x-mu)./sigma,m-1);
if lb == -Inf,
   p = tcdf((ub-mu)./sigma,m-1);
elseif ub == Inf,
   p = 1 - tcdf((lb-mu)./sigma,m-1);
else  
   p = diff(tcdf([(lb-mu)./sigma (ub-mu)./sigma],m-1));
end

hh = plot(x,y,'b-');
np = get(gca,'NextPlot');
set(gca,'Nextplot','add');
xl = get(gca,'Xlim');
if lb == -Inf,
  lb = xl(1);
  yll = [0; eps];
else
  yll = tpdf((lb-mu)./sigma,m-1);
  yll = [0; yll];
end

if ub == Inf,
   upper = xl(2);
   yul = [eps; 0];
else
   yul = tpdf((ub-mu)./sigma,m-1);
   yul = [yul; 0];
end
    
ll = [lb; lb];
ul = [ub; ub];
  
hh1 = plot(ll,yll,'b-',ul,yul,'b-');
if nargout == 2
  h = [hh; hh1];
end

k = find(x > lb & x < ub);
xfill = x(k);
xfill = [ll; xfill; ul];
yfill = [yll; y(k); yul];
fill(xfill,yfill,'y');

str = ['Probability Between Limits is ',num2str(p)];
title(str);
if ~isempty(np) 
   set(gca,'NextPlot',np);
end
xaxis = refline(0,0);
%whitebg(gcf,[0 0 0]);
%set(xaxis,'Color','w');

