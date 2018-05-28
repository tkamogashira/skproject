function cs = combineStruct(s1,s2, varargin);
% combineStruct - combine two struct into one
%   CombineStruct(S,T), where S and T are structs, is a struct
%   that has the fields of S and T combined. In case of 
%   identical fieldnames, the values in T take precedence.
%   Any empty structs among the inputs do not affect the
%   outcome.
%   
%   combineStruct(S1, S2, ... Sn) combines multiple structs.
%   Fields of Sk take precedence over Sm for k>m.
%
%   combineStruct(S,...,T, 'nonew') throws an error if any
%   new fields are in ...,T that are not in S.
%
%   combineStruct(S,...,T,'disjoint') throws an error if the
%   input structs S...T have any fieldnames in common.
%
%   See also CollectInStruct.

flag = '';
Nstruct = 2;
if nargin>2,
   if ischar(varargin{end}),
      flag = varargin{end};
      Nstruct = nargin-1;
   else, Nstruct = nargin;
   end
end

if Nstruct>2, % more than two struct to be combined - use good ol' recursion
   cs = combineStruct(s1,s2,flag);
   cs = combineStruct(cs, varargin{:});
   return;
end

% ----two structs from here-------

Disjoint = isequal('disjoint', lower(flag));
if isempty(s1), cs = s2;
elseif isempty(s2), cs = s1;
else, % s1 and s2 are structs
   fns = fieldnames(s2);
   if isequal('disjoint', lower(flag)),
      overlap = intersect(fns, fieldnames(s1));
      if ~isempty(overlap),
         error(['Common fieldname ''' overlap{1}  ''' in struct arguments of Disjoint call to CombineStruct.']);
      end
   elseif isequal('nonew', lower(flag)),
      news = setdiff(fns, fieldnames(s1));
      if ~isempty(news),
         error(['New fieldname ''' news{1}  ''' introduced by NoNew call to CombineStruct.']);
      end
   end
   cs = s1;
   N = length(fns);
   for ii=1:N,
      fn = fns{ii};
      cs = setfield(cs, fn, getfield(s2,fn));
   end
end

