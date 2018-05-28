function Str = readEDFVecStr(fid)

%B. Van de Sande 29-07-2003

NElem  = freadVAXG(fid, 1, 'uint16'); 
Str    = char(freadVAXG(fid, NElem, 'uchar')');

%Allocation on multiples of 4 bytes ...
N = 2 + NElem; 
NJmp = ceil(N/4)*4 - N;
fseek(fid, NJmp, 'cof');