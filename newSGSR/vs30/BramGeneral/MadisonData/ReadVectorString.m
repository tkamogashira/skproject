function Value = ReadVectorString(fid);

Value = [];

NElem = fread(fid, 1, 'uint16'); 
String = char(fread(fid, NElem, 'uchar')');

if isempty(String), Value = NaN;
else 
    [Value, Count, Err] = sscanf(String, '%f');
    if ~isempty(Err), Value = String; end
end

%Allocatie op veelvouden van 4 bytes ...
N = 2 + NElem;
Remainder = 4 - mod(N,4);
if Remainder == 4, Remainder = 0; end
fseek(fid, Remainder, 'cof');
