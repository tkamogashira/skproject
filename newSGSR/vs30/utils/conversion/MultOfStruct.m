function M = MultOfStruct(S,dim);
% MultOfStruct - returns max multiplicity of fiedls in struct
% SYNTAX
% M = MultOfStruct(S,dim);
% M = max(length(fields of S))
% Error is reported when different non-unity lengths occur
% among the fields of S.
% dim is dimension along which the length is evaluated;
% absent or 0 dim value: length = max(size)
if nargin<2, dim = 0; end;

if ~isstruct(S),
   error('non-struct input arg');
end
FNS = fieldnames(S);
M = 1;
for ii=1:length(FNS),
   fn = FNS{ii};
   if dim==0, L = length(getfield(S,fn));
   else, L = size(S,dim);
   end
   if L>1,
      if (M~=1) & (M~=L),
         error('unequal multiplicities in stimpar struct fields');
      end
      M = L;
   end;
end
