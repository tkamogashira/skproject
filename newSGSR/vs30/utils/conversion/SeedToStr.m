function Str = SeedToStr(Seed, MaxExp);

% converts integer in the range 0..61^MaxExp-1 into unique alphanumeric string
% default MaxExp=5, inversion fails for MaxExp>8 due to 32 bit storage of MatLab doubles

if nargin<2,
   MaxExp = 5;
end

if MaxExp>8,
   error('MaxExp too big for reliable inversion');
end


Base = 61;
Nmax = Base^MaxExp-1;

if ~isnumeric(Seed) | ~isreal(Seed) | (Seed<0) | Seed>Nmax,
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





