% MNtoEachChEachF0001_4_102_15
function SigChN=MNtoEachChEachF0001_4_102_15(M,N,V,FA)
P((1:90),103)=(FA)';
P((1:4),(1:102))=ones(4,102);
P((86:90),(1:102))=ones(5,102);
for C=1:102
    for g=5:85
        if mean(mean(M(C,((g-4):(g+5)),(1:15)),2))-mean(mean(N(C,((g-4):(g+5)),(1:15)),2))<0
            P(g,C)=1;
        else
            [H,P(g,C),ci]=ttest2(mean(M(C,((g-4):(g+5)),(1:15)),2),mean(N(C,((g-4):(g+5)),(1:15)),2),0.001,0);
        end;
    end;
end;
for Fp=1:90
    SigChN(Fp)=sum(P(Fp,(1:102))<0.001);
end;
PlotP=[[P;[V zeros(4,1)]] [SigChN 0 0 0 0]'];
assignin('base','PlotP',PlotP);
[i,j]=find(PlotP((1:90),(1:102))<0.001);
X=[i j];
for k=1:size(X,1)
    if PlotP(92,X(k,2))>0
        plot3(PlotP(93,X(k,2)),PlotP(94,X(k,2)),PlotP(X(k,1),103),'bo'),hold on;
    else
        plot3(PlotP(93,X(k,2)),PlotP(94,X(k,2)),PlotP(X(k,1),103),'b.'),hold on;
    end;
end;
plot3(PlotP(93,find(PlotP(92,(1:102))>0)),PlotP(94,find(PlotP(92,(1:102))>0)),ones(nnz(PlotP(92,(1:102))>0)),'ko'),hold on;
plot3(PlotP(93,find(PlotP(92,(1:102))==0)),PlotP(94,find(PlotP(92,(1:102))==0)),ones(nnz(PlotP(92,(1:102))==0)),'k.'),grid,hold on;          
end