function S = structmovefield(S, mf, tf);
% structPart - move a field of struct or struct array
%   S = structmovefield(S, 'foo1', 'foo2') changes the order of the fields
%   in s such that field foo1 will just precede field foo2. If foo2 is
%   empty, foo1 will be made the last field of S.
%
%   See also structPart.


% store and remove requested field
M = structpart(S, {mf});
S = rmfield(S, mf);

% locate target field
FNS = fieldnames(S);
if isempty(tf),
    it = numel(FNS)+1;
else,
    it = strmatch(tf, FNS, 'exact');
end

% split and patch
S1 = structpart(S, FNS(1:it-1));
S2 = structpart(S, FNS(it:end));
S = structjoin(S1, M, S2);





