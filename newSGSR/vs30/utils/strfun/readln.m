function [s, EOF]=readln(fid);
% READLN - reads one line from text file
N = 256;
s = blanks(N);
RET = char(10);
ii = 0; NN = N;
while 1,
   [c n] = fread(fid,1,'char');
   if n~=1, break; end;
   if c==RET, break; end;
   ii=ii+1;
   if ii>NN, % c does not fit in s; expand s
      s = [s blanks(N)];
      NN = NN + N;
   end
   s(ii) = c;
end
s = s(1:ii);
EOF = ~isequal(c,RET);
if ~EOF,
   [c n] = fread(fid,1,'char');
   if n~=1,
      EOF = 1;
   else, % undo read-ahead
      fseek(fid,-1,0);
   end
end
