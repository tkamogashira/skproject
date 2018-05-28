function ActionOverview(figh);
%  ActionOverview - display overview of action objects. Debug tool.
%     ActionOverview(figh)  
%     default figh is gcg.

if nargin<1, figh=gcg; end

[L, N]=guiActionList(gcg); 
for ii=1:N,
    a = L(ii);
    A = download(a.address);
    disp([a.FN ': ' status(A)]);
end
disp(' ');







