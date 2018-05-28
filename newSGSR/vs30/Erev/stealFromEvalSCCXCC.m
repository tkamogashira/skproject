function [tau, difcorr]=stealFromEvalSCCXCC(maxtau);
% stealFromEvalSCCXCC - steal diffcorr from EvalSCCXCC graph
%   syntax: [tau, difcorr]=stealFromEvalSCCXCC();

if nargin<1, maxtau=[]; end

hll=findobj(gcf, 'type', 'line');
hl = hll(20);
tau = get(hl,'xdata');
difcorr = get(hl,'ydata');

if ~isempty(maxtau), % restrict tau range
   iok = find(abs(tau)<=maxtau);
   tau = tau(iok); 
   difcorr = difcorr(iok);
end




