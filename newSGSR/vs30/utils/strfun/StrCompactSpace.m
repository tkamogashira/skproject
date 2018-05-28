function Cstr = StrCompactSpace(Str,Nsp);
% StrCompactSpace - removes heading & trailing space and reduces all multiple space by blank(s)
if nargin<2, Nsp=1; end;
SEP = blanks(Nsp);

% subsitute blanks for "linefeeds" and unroll
M = size(Str,1);
Str = [Str.' ; blanks(M)];
Str = deblank(Str(:).');

WasSpace = 1;
Cstr = '';
for ii=1:length(Str),
   if isspace(Str(ii)),
      if ~WasSpace, Cstr = [Cstr SEP]; end;
      WasSpace = 1;
   else,
      Cstr = [Cstr Str(ii)];
      WasSpace = 0;
   end
end

