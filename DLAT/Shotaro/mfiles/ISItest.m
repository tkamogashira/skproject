S=CALCISIH(ds,'nbin',20);
for k=1:length(S.hist)
    misI=find(S.hist(k).bincenters<0.5);
    M=S.hist(k).n;
    S.hist(k).mistriggerN=sum(M(misI));
    S.hist(k).mistriggerR=sum(M(misI))/sum(M);
end;
xm=4;
ym=fix(length(S.hist)/xm)+1;
for s=1:length(S.hist)
    subplot(ym,xm,s);
    bar(S.hist(s).bincenters,S.hist(s).n);
    S.hist(s).level=S.dsinfo.indepval(s);
    title([num2str(S.hist(s).level) 'dB']);
    xlabel(['#mistrig=' num2str(S.hist(s).mistriggerN) '; '  'Rmistrig=' num2str(S.hist(s).mistriggerR)]);
end;
Mis1=[S.hist(:).level];
Mis2=[S.hist(:).mistriggerN];
Mis3=[S.hist(:).mistriggerR];
Mis=[Mis1;Mis2;Mis3];
assignin('base','Mis',Mis);
