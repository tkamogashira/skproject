function Str = Seed2Str(Seed, MaxExp);
% Seed2Str - convert integer to string
%   Str = Seed2Str(Seed, L) converts integer Seed into unique 
%   alphanumeric string Str having length L. Seed must be a nonnegative
%   integer smaller than 61^L. L may not exceed 8.
%
%   See also Str2Seed.

if nargin<2,
   MaxExp = 5;
end

if MaxExp>8,
   error('L too big for reliable inversion');
end

Base = 61;
Nmax = Base^MaxExp-1;

if ~isnumeric(Seed) || ~isreal(Seed) || (Seed<0) || Seed>Nmax,
   try,  Sstr = num2str(Seed);
   catch, Sstr = '???';
   end
   error(['invalid seed value: ' Sstr]);
end

% convert Seed to 67-base number
StrIndex = zeros(1,MaxExp);
for iBase=(MaxExp-1):-1:0,
   phrumbs = Base^iBase;
   StrIndex(iBase+1) = 1+floor(Seed/phrumbs);
   Seed = rem(Seed, phrumbs);
end

CS = SeedCodeString;
Str = blanks(MaxExp);
for ichar=1:MaxExp,
   Str(ichar) = CS(StrIndex(ichar));
end





