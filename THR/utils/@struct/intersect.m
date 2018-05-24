function I = intersect(S,T, flag);
% struct/intersect - intersect for structs
%   intersect(S,T) is a struct with fields common to S and T, and
%   values of T.
%
%   intersect(S,T, 'ignorecase') ignores lower/upper case differences
%   when comparing the fieldnames of S and T, but uses the fieldnames
%   of T in the return value.
%
%   See also, struct/union.

if nargin<3, flag=''; end

FS = fieldnames(S);
FT = fieldnames(T);
if isequal('ignorecase',flag),
    fs = lower(FS);
    ft = lower(FT);
else,
    fs = FS;
    ft = FT;
end
imatch = find(ismember(ft, fs));
VT = struct2cell(T); % values of all fields in T
I = cell2struct(VT(imatch), FT(imatch));




