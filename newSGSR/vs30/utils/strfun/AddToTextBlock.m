function B = AddToTextBlock(Str, B, nmax)
% AddToTextBlock - add string to text block without exceeding max width
if nargin<2, B = ''; end;
if nargin<3, nmax=88; end;

if isempty(B),
   B = Str;
   return
end

% separate last line from B
LastLine = B(end,:);
while isspace(LastLine(end)), LastLine = LastLine(1:end-1); end
LastLine = [LastLine ' '];
B = B(1:end-1,:);

if (length(LastLine)+length(Str))>nmax,
   B = strvcat(B, LastLine);
   LastLine = '';
else,
end
LastLine = [LastLine Str];

B = strvcat(B, LastLine);

