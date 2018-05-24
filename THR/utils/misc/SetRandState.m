function [seed, Nmax]=SetRandState(OldSeed);
% SetRandState - set random generator in arbitrary but reproducible state 
%   Seed=SetRandState  or   Seed=SetRandState(nan)
%   sets the MatLab random generators (see RAND and RANDN) in
%   an arbitrary state derived from the clock, and returns a Seed that can
%   be used to reproduce that state of the RAND & RANDN generators.
%
%   SetRandState(Seed) reproduces the state described above.
% 
%   Note: SetRandState works for RAND and RANDN at the same time, although
%   they seem to have independent seeds.
%   seeds used in this function are integers in the range 0..61^5-1, so that 
%   they can be uniquely presented by a string of 5 alphanumerical chars 
%   not containing any zeros (see Seed2Str and Str2Seed).
% 
%   See also RAND, RAND.

if nargin<1, OldSeed = []; 
elseif isnan(OldSeed), OldSeed = []; 
end

Nmax = 61^5-1;
if isequal(OldSeed,'max'), % query
   seed = Nmax;
   return;
end


if isempty(OldSeed),
   % reset random generator using clock function (see help rand)
   rand('state',sum(100*clock));
   % get large random integer to use as reproducible seed
   OldSeed = round(Nmax*rand);
end


% multiple values: recursive call
if length(OldSeed)>1,
   seed = zeros(size(OldSeed));
   for ii=1:numel(OldSeed),
      seed(ii) = setRandState(OldSeed(ii));
   end
   return;
end

% single args from here
mess = checkRealNumber(OldSeed,[0 Nmax]);
if isempty(mess),
   if rem(OldSeed,1)~=0,
      mess = 'not an integer';
   end
end
if ~isempty(mess),
   error(['Invalid random seed: ' mess]);
end

% reset random generators using OldSeed
rand('state',OldSeed);
randn('state',OldSeed);

% return seed that reproduces current state of generator
seed = OldSeed;


