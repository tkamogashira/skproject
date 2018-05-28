function [l,b] = fact2(n)
%FACT2 decompose a number in product of two factors
%   [L, B] = FACT2(N) returns the two factors L and B so that L*B is the largest nearest square of N. This 
%   function is useful for creating figures with multiple axes. 

%B. Van de Sande 27-03-2003

if (n == 2), l = 2; b = 1; return; end
if isprime(n), [l,b] = fact2(n+1); return; end

fact = factor(n); s = length(fact);
while s > 2
    if mod(s, 2), fact = [(fact(1:2:s-1) .* fact(2:2:s-1)) fact(end)];
    else, fact = fact(1:2:s) .* fact(2:2:s); end
    s = length(fact);
end    

l = max(fact); b = min(fact);
