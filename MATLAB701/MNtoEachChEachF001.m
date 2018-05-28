% MNtoEachChEachF001
function SigChN=MNtoEachChEachF001(M,N,V,FA)
P((1:90),205)=(FA)';
D=M-N;
for C=1:204
    for f=1:90
        if mean(D(C,f,(1:30)))<0
            P(f,C)=1;
        else
            [H,P(f,C),ci]=ttest2(D(C,f,(1:30)),0,0.01,0);
        end;
    end;
end;
for Fp=1:90
    SigChN(Fp)=sum(P(Fp,(1:204))<0.01);
end;
PlotP=[[P;[V zeros(4,1)]] [SigChN 0 0 0 0]'];
assignin('base','PlotP',PlotP);
[i,j]=find(PlotP((1:90),(1:204))<0.01);
plot3(PlotP(93,j),PlotP(94,j),PlotP(i,205),'b.'),hold on;
plot3(PlotP(93,find(PlotP(92,(1:204))>0)),PlotP(94,find(PlotP(92,(1:204))>0)),ones(nnz(PlotP(92,(1:204))>0)),'ko'),hold on;
plot3(PlotP(93,find(PlotP(92,(1:204))==0)),PlotP(94,find(PlotP(92,(1:204))==0)),ones(nnz(PlotP(92,(1:204))==0)),'k.'),grid,hold on;          
end
