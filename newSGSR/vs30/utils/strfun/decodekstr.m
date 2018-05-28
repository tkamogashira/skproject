function str = decodekstr(str);
% DECODEKSTR - substitute 8000 for 8k, etc

if ~ischar(str) | isempty(str), return; end

while 1,
   kpos = findstr('k', str);
   if isempty(kpos), return; end;
   kpos = kpos(1);
   str = [str ' '];
   spos = kpos-1+min(findstr(' ',str(kpos:end)));
   ndigits = spos-kpos-1;
   if ndigits>3, 
      str = trimspace(str);
      return;
   end
   % insert zeros
   if ndigits<3,
      str = [str(1:spos-1) repmat('0',1,3-ndigits) str(spos:end)];
   end
   % delete 'k' and trailing white space
   str(kpos) = '';
   str = deblank(str);
end



