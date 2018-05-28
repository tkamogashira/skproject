function y = subsasgn(y, S, RHS);
% DATASET/SUBSASGN - SUBSASGN for DATASET objects
%   Dataset variables contain raw data; they are read-only.
%   It is an error to change their contents.
%
%   See also DATASET/SUBSREF

if isempty(y), y = dataset; end;
if isequal('()', S.type), % vector assignment - okay
   ii = S.subs{1};
   y(ii) = RHS;
   return
end

eee = ['Dataset variables contain raw data. Their content cannot be changed.'];
error(eee);