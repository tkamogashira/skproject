function Seed = StrToSeed(Str);
% converts alphanumerical string to number in the range 0..61^length(Str)-1
% inverse of SeedToStr
% string length may not exceed 8 chars

Base = 61;

if ~isstr(Str),
   try,  Sstr = num2str(Str);
   catch, Sstr = '???';
   end
   error(['invalid string value ' Sstr]);
end

MaxExp = length(Str);
if MaxExp>8,
   error('string too long for reliable inversion');
end


CS = SeedCodeString;

BB = 1; Seed = 0;
for ichar=1:MaxExp,
   Index = findstr(Str(ichar),CS)-1;
   if isempty(Index),
      error('illegal character in string arg');
   end
   Seed = Seed + BB*Index;
   BB = BB*Base;
end
