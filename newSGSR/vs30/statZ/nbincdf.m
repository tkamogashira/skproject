function y = nbincdf(x,r,p)
%NBINCDF Negative binomial cumulative distribution function.
%   Y=NBINCDF(X,R,P) returns the negative binomial cumulative distribution
%   function with parameters R and P at the values in X.
%
%   The size of Y is the common size of the input arguments. A scalar input  
%   functions as a constant matrix of the same size as the other inputs.    
%
%   The algorithm uses the cumulative sums of the binomial masses.


%   B.A. Jones 1-24-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.7 $  $Date: 1998/09/11 19:28:58 $

if nargin < 3, 
    error('Requires three input arguments.'); 
end 

scalarrp = (prod(size(r)) == 1 & prod(size(p)) == 1);

[errorcode x r p] = distchck(3,x,r,p);

if errorcode > 0
    error('Requires non-scalar arguments to match in size.');
end

% Initialize Y to 0.
y=zeros(size(x));


% Compute Y when 0 < X.
xx = floor(x);
k = find(xx >= 0);

% Accumulate the binomial masses up to the maximum value in X.
if any(k)
    val = max(max(xx));
    if scalarrp
        tmp = cumsum(nbinpdf(0:val,r(1),p(1)));
        y(k) = tmp(xx(k) + 1);
    else
     idx = [0:val]';
        compare = idx(:,ones(size(k)));
        index = xx(k);
		index = index(:);
        index = index(:,ones(size(idx)))';
        rbig = r(k);
		rbig = rbig(:);
        rbig = rbig(:,ones(size(idx)))';
        pbig = p(k);
		pbig = pbig(:);
        pbig = pbig(:,ones(size(idx)))';
        y0 = nbinpdf(compare,rbig,pbig);
        indicator = find(compare > index);
        y0(indicator) = zeros(size(indicator));
        y(k) = sum(y0,1);
    end
end

% Make sure that round-off errors never make P greater than 1.
k = find(y > 1);
if any(k)
    y(k) = ones(size(k));
end

% Return NaN if any arguments are outside of their respective limits.
k1 = find(r < 1 | p < 0 | p > 1 | round(r) ~= r | x < 0); 
if any(k1)
    tmp = NaN;
    y(k1) = tmp(ones(size(k1))); 
end
