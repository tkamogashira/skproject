function sn = nthElement(s,n,noRecursion);
% nthElement - extract nth row of vectors or struct elements
% SYNTAX:
% function sn = nthelement(s);
% sn is structure with saem fields as s containing
% the nth row if the size is large enough, otherwise 
% the 1st element
% if the element is a struct, recursive tracking is done
% unless noRecursion.

if nargin<3, noRecursion=0; end;
if ~isstruct(s),
   sn = s(min(n,size(s,1)),:);
   return;
end;

fns = fieldnames(s);
Nf = size(fns);
sn = [];
for ii=1:Nf,
   fn = fns{ii};
   svalue = getfield(s,fn);
   if isstruct(svalue) & (length(svalue)<=1),
      if noRecursion, sn = setfield(sn, fn, []);
      else, sn = setfield(sn, fn, nthElement(svalue,n));
      end;
   elseif ~isempty(svalue),
      index = min(n,size(svalue,1));
      sn = setfield(sn, fn, svalue(index,:));
   else, % empty value
      sn = setfield(sn, fn, svalue);
   end
end


