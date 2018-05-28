function dp=polydiff(p);
% polydiff - first derivative of polynomial

N = length(p)-1; % order
dp = (N:-1:1).*p(1:N);

