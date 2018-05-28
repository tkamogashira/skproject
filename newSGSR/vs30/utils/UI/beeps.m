function beeps(n)
% beep - beep
if nargin<1, n = 1; end;
for ii=1:n,
   fprintf(2,'\a');
end
