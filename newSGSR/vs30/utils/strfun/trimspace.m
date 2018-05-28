function str = trimspace(str);
% TRIMSPACE - remove leading and trailing space and substitute single space for multiple space

if ~ischar(str), return; end;
if isempty(str), return; end;

iwhite = [1 isspace(str)];
istay = find(~iwhite(2:end) | ~iwhite(1:end-1));
str = str(istay);
if isempty(str), return;
elseif isspace(str(end)),
   str = str(1:end-1);
end

