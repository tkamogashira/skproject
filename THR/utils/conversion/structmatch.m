function a = structmatch(A,S,FNS);
% structmatch - find elements of struct array whose field match a struct
%   S = structmatch(A, S, {'field1' 'field2' ...});
%   returns those elements of struct array A whose fields field1, etc,
%   match those of struct S. Field values must be numerical or string
%   (i.e., evaluable with the == operator).

q = true(1,numel(A));
for ii=1:numel(FNS),
    fns = FNS{ii};
    q = q & [A.(fns)]==S.(fns);
end
a = A(q);







