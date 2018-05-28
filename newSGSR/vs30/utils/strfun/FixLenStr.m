function FS = FixLenStr(S,len,Left);
% FIXLENSTR - trucates string or appends/prepends it with blanks to get a fixed length
% SYNTAX
%    FS = FixLenStr(S,len,Left);
% Defaults: Left=0, i.e.
% truncating is done by removing right-most chars
% spaces are appended
if nargin<3, Left=0; end;

oldlen = length(S);

if Left, % left-truncate or prepend
   if oldlen>len, % truncate
      FS = S((oldlen-len+1):oldlen);
   else, % prepend spaces
      FS = [blanks(len-oldlen) S];
   end
else, % right-truncate or apppend
   if oldlen>len, % truncate
      FS = S(1:len);
   else, % append spaces
      FS = [S blanks(len-oldlen)];
   end
end
