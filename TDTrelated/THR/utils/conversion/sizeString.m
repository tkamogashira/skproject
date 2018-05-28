function Str = sizeString(S);
% sizeString - string describing size
%    sizeString([2 3]) returns the string '2x3', etc.

if ~isnumeric(S) || ~isequal(1,size(S,1)),
    error('Input arg Smust be valid size, i.e., 1xM array.');
end

Str = trimspace(num2str(S));
Str = strrep(Str,' ', 'x');

