function [D, N, rtol] = fareyRat(x, tol);
% fareyRat - rational approx based on farey-like bracketing algorithm
%    For 0<abs(X)<1, [D, N]=Fareyrat(X,tol) tries to find lowest possible N for 
%    which X is close to D/N, i.e., abs(X-D/N)<=tol*abs(X)
%    for abs(X)>1, D is minimized.

if x==0,
   D = 0; N = 1; rtol = 0; return;
elseif x==1, 
   D = 1; N = 1; rtol = 0; return;
end

Nega = x<0;
x = abs(x);
maxdev = tol*x;
Reci = abs(x)>1;

origx = x;
if Reci, x=1/x; end

D0 = 0; N0 = 1;
D1 = 1; N1 = 1;
if (1+tol)*x<5e-2,
   N1 = floor(1/(1+tol)/x)-10;
end
if x<10*tol,
   N0 = floor(2/x);
end
tic
while 1,
   D = D0+D1; N = N0+N1; % D0/N0 < D/N < D1/N1
   G = gcd(D,N);
   D = round(D/G);
   N = round(N/G);
   % disp(num2str([D0 N0 nan D N nan D1 N1]))
   approx = D/N;
   if Reci,
      if abs(1/approx-origx)<=maxdev, break; end
   else,
      if abs(approx-x)<=maxdev, break; end
   end
   % squeeze
   if approx<x, [N0, D0] = deal(N,D);
   else, [N1, D1] = deal(N,D);
   end
   if toc>2, error('Time out.'); end
end

if Reci, [D, N] = swap(D, N); end
rtol = abs(D/N/origx-1);
if Nega, D = -D; end

