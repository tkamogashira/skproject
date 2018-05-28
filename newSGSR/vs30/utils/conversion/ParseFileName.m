function [Drive, Dir, Name, Ext] = ParseFileName(ffn);

% function [Drive Dir Name Ext] = ParseFileName(ffn);
% split DOS-style filename in drive, dir, name and extension
% delimeters '.' ':' '\' are not part of the portions
% Note: all spaces are removed

% remove spaces
if ~isempty(ffn), ffn(find(ffn==' ')) = []; end;

Ext = '';
lastperiod = max(findstr('.', ffn));
if ~isempty(lastperiod),
   [ffn Ext] = Split(ffn, lastperiod);
end
Drive = '';
firstcolon = min(findstr(':', ffn));
if ~isempty(firstcolon),
   [Drive ffn] = Split(ffn, firstcolon);
end
Dir = '';
Name = ffn;
lastbackslash = max(findstr('\', ffn));
if ~isempty(lastbackslash),
   [Dir Name] = Split(ffn, lastbackslash);
end

% ---local---
function [x1, x2] = Split(x,n);
x1 = x(1:(n-1)); if isempty(x1), x1 = ''; end;
x2 = x((n+1):end); if isempty(x2), x2 = ''; end;