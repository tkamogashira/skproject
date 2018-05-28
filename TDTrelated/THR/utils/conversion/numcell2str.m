function Str = numcell2str(C);
% numcell2str - convert cell array of numericals to string
%    numcell2str(C) converts cell array C into string, provided that each
%    element of C is a numerical vector or a [].
%    C must itself be a vector.
%
%  Example
%    numcell2str({1:3 [] [3 5 7].'})
%    ans = 
%
%  See also num2str.

if ~iscell(C),
    error('Input arg C must be cell array.')
elseif ~(isequal({},C) || isvector(C)),
    error('Input arg C must be {} or vector.');
end

Str = '{';
for ii=1:numel(C),
    if ii>1, Str = [Str ' ']; end
    c = C{ii};
    if ~isnumeric(c) || (~isequal([],c) && ~isvector(c)),
        error('All elements of C must be numerical vectors or [].');
    end
    if isempty(c),
        str = '[]';
    else,
        str = [trimspace(num2str(c(:).'))];
        if numel(c)>1, str = ['[' str ']']; end
        if size(c,1)>1,
            str = [str '.'''];
        end
    end
    Str = [Str str];
end
Str = [Str '}'];
if size(C,1)>1, % indicate column vector by '
    Str = [Str ''''];
end

