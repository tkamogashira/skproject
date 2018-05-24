function X = substitute(X,Old,New);
% Substitute - replace specific value(s) in a matrix by other value(s)
%   Substitute(X,Old,New) replaces all elements in X that are equal to Old by New.
%   Old and New may be vectors of equal length, in which case each of the
%   Old values Old(k) is replaced by the respective new New value New(k).

Nval = length(Old(:));

% to avoid side effects, first collect all occurrences of Old values...
% ...only then start replacing elements.
ihit = cell(1,Nval); % indices of occurrence of elements Old
for ival=1:Nval,
   old = Old(ival);
   ihit{ival} = find(X==old);
end
% now replace
for ival=1:Nval,
   X(ihit{ival}) = New(ival);
end












