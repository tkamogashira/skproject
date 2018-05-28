function Str=debrace(Str);
%  debrace - remove surrounding braces [] from string
%    debrace(S) removes any braces [] surrounding string S.
%    Before and after removing the braces, any heading and trailing blanks 
%    are removed and multiple consecutive blanks are replaced by single
%    blanks.
%
%    See also TrimSpace.

Str = trimspace(Str);
if isempty(Str), return; end % to prevent errors when idexing
while isequal('[', Str(1)) && isequal(']', Str(end)),
    Str = trimspace(Str);
    Str = Str(2:end-1);
    Str = trimspace(Str);
    if isempty(Str), return; end
end

