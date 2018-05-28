function F = getfieldCI(S, FN, DDD);
% getfieldCI - case-insensitive version of getfield
%   Optional 3rd arg suppresses error and is returned
%   if named field is not found
fnd = lower(FN);
FNS = fieldnames(S);
for ii=1:length(FNS),
   fn = FNS{ii};
   if isequal(lower(fn), fnd),
      F = getfield(S,fn);
      return
   end
end
if nargin>2,
   F = DDD;
else,
   error(['Reference to non-existent field ''' FN '''']);
end