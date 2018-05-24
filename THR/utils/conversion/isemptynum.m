function ie = isemptynum(x);
% ISEMPTYNUM - checks if a number is equal to []
%    Note: isequal cannot be trusted in general for these
%    kinds of comparisons. E.g. isequal('',[]) == 1

ie = isnumeric(x) & isempty(x);
