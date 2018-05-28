function S = FreqString(Freq,n);

% FREQSTRING - converts positive number to 3-char string, e.g/ 1300 -> 1k3, 23000 -> 23k
% SYNTAX 
%   S = FreqString(Freq,n);
% defaults length of string is 3.

if nargin<2, n=3; end;
if Freq>=100e3,
   error('freqency too large');
end


if n==3,
   Freq100 = round(Freq/100);
   if Freq100>99, % 23000 -> 23k, etc
      Freq1000 = round(Freq/1000);
      S = [num2str(Freq1000) 'k'];
   elseif Freq100>9, % 2300 -> 2k3, etc
      Freq1000 = floor(Freq100/10);
      Freq100 = rem(Freq100,10);
      S = [num2str(Freq1000) 'k' num2str(Freq100)];
   else % 568 -> 568, etc
      S = num2str(Freq);
   end
end
