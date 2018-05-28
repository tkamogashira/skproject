function l = Location(AAA);
% LOCATION - string identifying location of measurement
Town = '??';
Compu = '**';

if nargin<1,
   if inLeuven,
      Town = 'Leuven';
      if atBigScreen,
         Compu = 'Bigscreen';
      end
   elseif inUtrecht,
      Town = 'Utrecht';
   elseif inRotterdam,
      Town = 'Rotterdam';
   end
end

l = [Town '/' Compu];