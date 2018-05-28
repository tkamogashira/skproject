function id = isdigit(str);
% ISDIGIT - true for digit characters '0' to '9'
id = 0;
if ~ischar(str), return; end
str = double(str);
dn = double('0123456789');
id = (str>=min(dn)) & (str<=max(dn));

