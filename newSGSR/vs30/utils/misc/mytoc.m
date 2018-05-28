function t = mytoc(keyword)
% MYTOC- multiple implementation of MatLab TOC

global MYTICTOC
if isempty(MYTICTOC),
  error('You must call MYTIC before calling MYTOC.');
end

Index = lower(keyword(1))-'a'+1;

if isnan(MYTICTOC(Index,1)),
  error(['MYTIC not called with keyword ' keyword]);
end

if nargout < 1
   elapsed_time = etime(clock,MYTICTOC(Index,:))
else
   t = etime(clock,MYTICTOC(Index,:));
end
