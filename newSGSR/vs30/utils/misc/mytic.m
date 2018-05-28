function mytic(keyword)
% multiple implementation of MatLab TIC - only first char of keyword is used!!

global MYTICTOC
if isempty(MYTICTOC) | isequal(keyword,'reset'),
   MYTICTOC = NaN + zeros(26,6);
end
Index = lower(keyword(1))-'a'+1;
MYTICTOC(Index,:) = clock;
