function [droe, SPLnoise, CHist]=levelErevana(TT,iseq,maxDF);
% LevelErevana - evaluate mod depth of level-erev
plotPar = 'n';
if nargin<3,
   maxDF = 2e3;
elseif ischar(maxDF),
   plotPar = maxDF;
   maxDF = 2e3;
end
tpar = sgsrPar(TT,iseq);
maxDF = min(maxDF,tpar.NoiseBW);
SPLnoise = tpar.SPLnoise;
Nsub = SGSRnSubRec(TT,iseq);
Cstim = ErevRetrieveCstim(TT,iseq);
droe = nan+SPLnoise;
for isub=1:Nsub,
   [XC, ff, sel, DC, CHist{isub}] = ErevAnalyze3(TT,iseq,isub);   
   N = length(CHist{isub});
   tozero = round(N*1e-3*Cstim(isub).DT*maxDF);
   SCHist = fft(CHist{isub});
   SCHist(1+tozero:end-tozero) = 0;
   CHist{isub} = ifft(SCHist);
   droe(isub) = std(real(CHist{isub}));
end
if nargout<1,
   figure(gcf);
   xplot(SPLnoise,droe,plotPar);
end

