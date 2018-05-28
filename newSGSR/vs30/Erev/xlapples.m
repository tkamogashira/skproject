function xlapples(AA, phOffset, cdelay, CF);
% xlapples(AA, phOffset, cdelay);

if nargin<2, phOffset=0; end 
if nargin<3, cdelay=1; end % ms comp delay
if nargin<4, CF=[]; end 

NY = length(AA);
% make sure phOffset is long enough
phOffset(1+NY)=0;
for ii=1:NY; 
   freq = [AA{ii}.Fcar]; 
   for jj=1:length(AA{ii}), 
      Aj = AA{ii}(jj); 
      PH = Aj.TRFphase; pm = pmask(Aj.RScar<=0.001);
      PH = delayPhase(PH, Aj.Fcar, cdelay-Aj.CDELAY, 0);
      xplot(Aj.Fcar, phOffset(ii)+PH+pm, [ploco(ii) '.-']); 
   end; 
   if ~isempty(CF),
      PH = delayPhase([AA{ii}.TRFphase], CF(ii), cdelay-Aj.CDELAY, 0); 
      [dum iCF]=min(abs(CF(ii)-freq)); 
      xplot(CF(ii), phOffset(ii)+PH(iCF),[ploco(ii) 'o'], 'markersize', 10, 'markerfacecolor', ploco(ii)); 
   end
end
title(['compensating delay: ' num2str(cdelay) ' ms']);
grid on









