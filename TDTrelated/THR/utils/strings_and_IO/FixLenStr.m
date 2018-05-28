function FS = FixLenStr(S,len,Left);
% FIXLENSTR - truncate string or append/prepend it with blanks to get a fixed length
%    S = FixLenStr(S,len,Left) forces S to have length len by either
%    removing characters or padding spaces.
%    Defaults: Left=0, i.e., truncating is done by removing right-most chars
%    or by appending spaces.
%    If Left, left-most chars are removed or spaces are prepended.

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
