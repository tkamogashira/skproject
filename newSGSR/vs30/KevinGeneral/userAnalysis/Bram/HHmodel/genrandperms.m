function P = genrandperms(Nvec, Nperms)
%GENRANDPERMS generate random permutations

%B. Van de Sande 21-08-2003

Nelem     = length(Nvec); 
MaxNperms = prod(Nvec);

if Nperms > MaxNperms, error('Requested permutations exceeds maximum number of permutations.'); end

if (Nperms/MaxNperms) > 0.5,
    P = genperms(Nvec);
    idx = randperm(MaxNperms); idx = idx(1:Nperms);
    P = P(idx, :);
else,
    Ndone = 0; Nleft = Nperms;
    while ~isequal(Ndone, Nperms),
        V = repmat(Nvec, Nleft, 1);
        P(Ndone+1:Nperms, :) = round(rand(Nleft, Nelem) .* V);
        
        P(any((P == 0), 2), :) = [];
        P = unique(P, 'rows');
        
        Ndone = size(P, 1);
        Nleft = Nperms - Ndone;
    end
end