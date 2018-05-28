function str = Bracket(str, addBracket, btype);
% bracket - add or remove brackets to/from string
%   syntax: str = Bracket(str, addBracket, btype);

if nargin<2, addBracket = 1; end % default action: add brackets
if nargin<3, btype = '[]'; end

b1 = btype(1);
b2 = btype(2);

if addBracket, str = [b1 str, b2];
else,
   str = strSubst(str, b1, '');
   str = strSubst(str, b2, '');
end






