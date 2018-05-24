function [S, mess] = MultiStruct(S, exceptionalFields);
% MultiStruct - convert struct with multi-values fields to array of struct with single-valued fields
%   SN = MultiStruct(S) returns a struct array SN with the same fields as S, in which 
%   multiple-valued numeric fields and cell arrays of strings are dealt to the respective elements 
%   of SN, for example:
%   S = 
%      a: 'hello'
%      b: [1 2]
%      c: {'string1' 'string2'}
%      d:  [20 10]
%      e: {'single-element cellstring'}
%
%   SN(1) = 
%      a: 'hello'
%      b: 1
%      c: 'string1'
%      d: 20
%      e: 'single-element cellstring'
%
%   SN(2) = 
%      a: 'hello'
%      b: 2
%      c: 'string2'
%      d: 10
%      e: 'single-element cellstring'
%
%   If several numeric fields are multi-valued, their sizes must be equal.
%   Note that fields that are not numeric or cellstring-values are left alone, 
%   regardless of their sizes, and that single-element cellstrings are "unpacked"
%   to their non-cell string values.
%
%   By definition, MultiStruct([]) equals [];
%
%   MultiStruct(S, {'fieldname1' 'fieldname2' ..}) makes an exception for
%   the fields in the list; any multiple values in those fields will not result in
%   splitting up the struct S.
%
%   See also CollectInStruct.

if nargin<2, exceptionalFields = {}; end; % default: no exceptions
exceptionalFields = cellstr(exceptionalFields);

if isempty(S), mess = ''; return; end
FNS = fieldnames(S);
N = length(FNS);
for ii=1:N,
   fv = getfield(S, FNS{ii});
   isException = ismember(lower(FNS{ii}), lower(exceptionalFields));
   if isnumeric(fv) & ~isException, 
      SIZ(ii,1:2) = size(fv);
   elseif iscellstr(fv) & ~isException, 
      SIZ(ii,1:2) = size(fv);
      if isequal([1 1], size(fv)), % unpack single-element cellstr 
         S = setfield(S, FNS{ii}, fv{1});
      end
   else, 
      SIZ(ii,1:2) = [1 1];
   end
end

imult = find(SIZ(:,1).*SIZ(:,2)>1); % row numbers of multi-valued sizes
if isempty(imult), return; end
cSIZ = SIZ(imult,1) + i*SIZ(imult,2);
if length(unique(cSIZ))>1,
   error('All non-scalar numerical/cellstr fields of S must have same size.');
end

newSize = round([real(max(cSIZ)) imag(max(cSIZ))]);
Snew = repmat(S, newSize); % correct size but simple multiple copy
% deal multiple-valued fields
for ii=imult(:)',
   fv = getfield(S, FNS{ii});
   for irow=1:size(fv,1),
      for icol=1:size(fv,2),
         if isnumeric(fv),
            Snew(irow,icol) = setfield(Snew(irow,icol), FNS{ii}, fv(irow,icol));
         elseif iscellstr(fv),
            Snew(irow,icol) = setfield(Snew(irow,icol), FNS{ii}, fv{irow,icol});
         end
      end
   end
end
S = Snew;








