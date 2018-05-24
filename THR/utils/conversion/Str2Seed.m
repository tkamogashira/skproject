function Seed = Str2Seed(Str);
% Str2Seed - convert char string into unique integer.
%   Str2Seed(Str) returns the integer I coded into char string Str by
%   a previous call Seed2Str(I,..).
%
%   See also Seed2Str.

Base = 61;

if ~ischar(Str),
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
