%
%
%	GetF0median(F0sequence,NumMed)
%
function F0median = GetF0median(F0sequence,NumMed)

if nargin < 2, NumMed = []; end;
if length(NumMed) == 0,NumMed = 5; end; 

[NumCh, LenF0] = size(F0sequence);

Mtx = zeros(NumMed,LenF0+NumMed);

for nm = 1:NumMed
  nnl = nm-1+(1:LenF0);
  Mtx(nm,nnl) = F0sequence(:)';
end;

aa = median(Mtx,1);
F0median = aa(fix(NumMed/2)+(1:LenF0));



