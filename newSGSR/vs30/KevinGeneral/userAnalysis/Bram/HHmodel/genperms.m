function P = genperms(Nvec)
%GENPERMS generate permutations

%B. Van de Sande 21-08-2003

Nelem  = length(Nvec);
Nperms = prod(Nvec);

P = zeros(Nperms, Nelem);

for n = 1:Nelem, 
    P(:, n) = repmat(mmrepeat((1:Nvec(n)), prod(Nvec(n+1:end)))', Nperms/prod(Nvec(n:end)), 1); 
end