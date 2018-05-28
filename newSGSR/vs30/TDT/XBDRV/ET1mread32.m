function tbuf=ET1mread32(din,NNN);

% function tbuf=ET1mread32(din);
% multiple read32 from ET1
% uses ET1report to determine # values to read
% default din=1

if nargin<1, din=1; end;
if nargin<2, NNN=0; end;

NN = ET1report;
tbuf=zeros(1,min(NN,1e6));
for ii=1:NN
   for jj=1:NNN, s=23^0.5; end;
   tt = s232('ET1read32', din);
   if tt==-1, tbuf = tbuf(1:(ii-1)); break; end;
   tbuf(ii)=tt;
end;

