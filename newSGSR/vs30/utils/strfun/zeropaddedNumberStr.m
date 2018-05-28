function str = zeropaddedNumberStr(number, Len);

str = num2str(number);
ToPad = Len-length(str);
for ii=1:ToPad,
   str = ['0' str];
end


