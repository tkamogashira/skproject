function [seed, Nmax]=SetRandState(OldSeed)

% SetRandState - set random generator in arbitrary but reproducible state 
%    seed = SetRandState;
%    sets the MatLab random generator of RAND and RANDN in
%    an arbitrary but reproducible state.
%
%    The state of the random generator is reproduced by calling
%    SetRandState(seed).
%    
%    SetRandState('current') returns the current seed.
%  
%    The seeds used by setRandState are integers in the range 0..61^5-1, 
%    so that they can be uniquely presented by a string of 5 alphanumerical 
%    chars not containing any zeros (see SeedToStr and StrToSeed).
%    SetRandState('max') returns the maximum value of the seed, i.e., 61^5-1.
% 
%    See also SeedToStr, StrToSeed.

%---------------- CHANGELOG ----------------
% 12/01/2011    Abel   Reverted to "Legacy Mode" syntax for rand and randn


persistent LastSeed

if nargin<1
    OldSeed = [];
end

Nmax = 61^5-1;
if isequal(OldSeed,'max') % query of maximum alue of seed
   seed = Nmax;
   return
elseif isequal(OldSeed,'current') % query of current value of seed
   seed = LastSeed;
   return
end

%By Abel: reset of randn was never inplemented? 
if isempty(OldSeed)
   % reset random generator using clock function (see help rand)
   s = RandStream('swb2712', 'Seed', sum(100*clock));
   RandStream.setDefaultStream(s);
   %rand('state',sum(100*clock));
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
mess = CheckRealNumber(OldSeed,[0 Nmax]);
if isempty(mess),
   if rem(OldSeed,1)~=0,
      mess = 'not an integer';
   end
end
if ~isempty(mess),
   error(['Invalid random seed: ' mess]);
end

% reset random generators using OldSeed
% By Abel: 
%	Lets keep this in the old "Legacy Syntax" since there is only one RandStream
%   Object for both rand/randn. Otherwise we have to change the
%   SetRandState function to include a flag for rand or randn resetting.
%   (see "Updating Your Random Number Generator Syntax" in matlab
%   documentation)
% RandStream.setDefaultStream(RandStream('swb2712', 'Seed', OldSeed));
rand('state',OldSeed);
randn('state',OldSeed);

% return seed that reproduces current state of generator
seed = OldSeed;
LastSeed = seed; % store for query (see above)

