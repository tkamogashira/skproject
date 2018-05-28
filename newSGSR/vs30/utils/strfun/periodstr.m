function ps=periodstr(s,MaxLen);

N = length(s);
perChar = '.';
Nper = 2;
perStr = ''; for ii=1:Nper, perStr = [perStr perChar]; end;
if N<=MaxLen,
   ps = s;
else
   istart = N-MaxLen+1+Nper;
   ps = [perStr s(istart:N)];
   ps = ps(1:MaxLen); % in case Maxlen<Nper
end


