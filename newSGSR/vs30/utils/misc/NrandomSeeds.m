function seeds=NRandomSeeds(N, OldSeed);

% NRandomSeeds = return N reproducible random seeds.
%   NRandomSeeds(N, OldSeed) is a N-vector containing N
%   random seeds a la SetRandomState, the first of which
%   equals OldSeed. 

if nargin<2, OldSeed = []; end

seeds = zeros(1,N);
seeds(1) = setRandState(OldSeed);
Nmax = setRandState('max');

seeds(2:N) = round(Nmax*rand(1,N-1));
